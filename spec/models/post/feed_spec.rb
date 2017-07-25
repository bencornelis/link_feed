require "rails_helper"

describe Post::Feed do
  describe "#posts" do
    let!(:followees)    { create_list(:user, 2) }
    let!(:non_followee) { create(:user) }
    let!(:user)         { create(:user) { |user| user.followees = followees } }

    subject(:feed) { Post::Feed.new(user: user) }

    it "only returns posts shared by the user's followees" do
      post1 = create(:post) { |post| post.users_shared_by << followees.first }
      post2 = create(:post) { |post| post.users_shared_by << non_followee }

      expect(feed.posts).to contain_exactly post1
    end

    it "orders posts by Hacker News Score by default" do
      # score - (S - 1)/(T + 2)^1.8
      # S - number of followee shares
      # T - number of seconds since creation
      posts = []
      Timecop.freeze(1.day.ago) do
        2.times do |i|
          posts << create(:post) { |post|
            post.users_shared_by << followees.take(i+1) }
        end
      end

      expect(feed.posts).to eq posts.reverse
    end

    context "when filtering by tag" do
      subject(:feed) { Post::Feed.new(user: user, tag: "tag1") }
      let!(:post1) do
        create(:post, tag_names: "tag1") { |post|
          post.users_shared_by << followees.first }
      end

      let!(:post2) do
        create(:post, tag_names: "tag2") { |post|
          post.users_shared_by << followees.first }
      end

      it "only includes posts with that tag" do
        expect(feed.posts).to contain_exactly post1
      end
    end

    context "when filtering by page" do
      subject(:feed) { Post::Feed.new(user: user, page: 2, per_page: 1) }
      let!(:post1) { create(:post) { |post| post.users_shared_by << followees.first } }
      let!(:post2) { create(:post) { |post| post.users_shared_by << followees.first } }

      it "only shows that page" do
        expect(feed.posts.length).to eq 1
      end
    end

    context "when sorting by time" do
      subject(:feed) { Post::Feed.new(user: user, sort: "time") }

      let!(:two_day_old_post) do
        Timecop.freeze(2.days.ago) do
          create(:post) { |post| post.users_shared_by << followees.first }
        end
      end

      let!(:day_old_post) do
        Timecop.freeze(1.day.ago) do
          create(:post) { |post| post.users_shared_by << followees.first }
        end
      end

      let!(:new_post) do
        create(:post) { |post| post.users_shared_by << followees.first }
      end

      it "puts the most recent posts first" do
        expect(feed.posts).to eq [new_post, day_old_post, two_day_old_post]
      end
    end
  end
end
