require "rails_helper"

describe Post::Feed do
  describe "#posts" do
    let!(:user)         { create :user_with_followees }
    let(:followee)      { user.followees.first }
    let!(:non_followee) { create :user }

    subject(:posts) { feed.posts }

    context "by default" do
      let(:feed) { Post::Feed.new(user: user) }

      it "only returns posts shared by the user's followees" do
        post = create :post, users_shared_by: [followee]
        create :post, users_shared_by: [non_followee]

        expect(posts).to contain_exactly post
      end

      it "orders posts by Hacker News Score by default" do
        # score - (S - 1)/(T + 2)^1.8
        # S - number of followee shares
        # T - number of seconds since creation
        all_posts = []
        Timecop.freeze(1.day.ago) do
          all_posts << create(:post, users_shared_by: user.followees)
          all_posts << create(:post, users_shared_by: [followee])
        end

        expect(posts.to_a).to eql all_posts
      end
    end

    context "when filtering by tag" do
      let(:feed) { Post::Feed.new(user: user, tag: "tag1") }

      let!(:post1) do
        create :post, tag_names: ["tag1"], users_shared_by: [followee]
      end

      let!(:post2) do
        create :post, tag_names: ["tag2"], users_shared_by: [followee]
      end

      it "only includes posts with that tag" do
        expect(posts).to contain_exactly post1
      end
    end

    context "when filtering by page" do
      let(:feed) { Post::Feed.new(user: user, page: 2, per_page: 1) }

      before { create_list :post, 2, users_shared_by: [followee] }

      it "only shows that page" do
        expect(posts.length).to eql 1
        expect(posts.first).to be_a Post
      end
    end

    context "when sorting by time" do
      let(:feed) { Post::Feed.new(user: user, sort: "time") }

      let!(:two_day_old_post) do
        Timecop.freeze(2.days.ago) do
          create :post, users_shared_by: [followee]
        end
      end

      let!(:day_old_post) do
        Timecop.freeze(1.day.ago) do
          create :post, users_shared_by: [followee]
        end
      end

      let!(:new_post) { create :post, users_shared_by: [followee] }

      it "puts the most recent posts first" do
        expect(posts.to_a).to eql [new_post, day_old_post, two_day_old_post]
      end
    end
  end
end
