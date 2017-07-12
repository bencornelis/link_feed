require "rails_helper"

describe Post::Feed do
  let!(:followees)    { create_list(:user, 3) }
  let!(:non_followee) { create(:user) }

  let!(:user) do
    create(:user) { |user|
      user.followees = followees }
  end

  describe "#by_score" do
    subject(:feed) { Post::Feed.new(user: user) }

    it "only returns posts shared by the user's followees" do
      post1 =
        create(:post) { |post|
          post.users_shared_by << followees.first }

      post2 =
        create(:post) { |post|
          post.users_shared_by << non_followee }

      expect(feed.by_score).to contain_exactly post1
    end

    describe "ordering posts by adapted Hacker News score" do
      # score - (S - 1)/(T + 2)^1.8
      # S - number of followee shares
      # T - number of seconds since creation

      context "when posts are concurrent" do
        let!(:concurrent_posts) do
          Timecop.freeze(1.day.ago) do
            (1..3).map { |n|
              create(:post) { |post| post.users_shared_by << followees.take(n) } }
          end
        end

        it "orders by score" do
          expect(feed.by_score).to eq concurrent_posts.reverse
        end
      end

      context "when posts have same number of shares" do
        let!(:equally_shared_posts) do
          (2..4).map do |n|
            Timecop.freeze(n.days.ago) do
              create(:post) { |post| post.users_shared_by = followees }
            end
          end
        end

        it "orders by time" do
          expect(feed.by_score).to eq equally_shared_posts
        end
      end

      context "when filtering by tag" do
        subject(:feed) { Post::Feed.new(user: user, tag: "tag1") }

        let!(:posts) do
          (1..3).map do |n|
            tag = n.odd? ? "tag1" : "tag2"
            create(:post, tag_names: tag) { |post| post.users_shared_by = followees.take(n) }
          end
        end

        it "orders posts with the tag by score" do
          expect(feed.by_score).to eq [posts[2], posts[0]]
        end
      end

      context "when filtering by page" do
        subject(:feed) { Post::Feed.new(user: user, page: 2, per_page: 1) }

        let!(:post1) do
          create(:post) { |post| post.users_shared_by = followees.take(1) }
        end

        let!(:post2) do
          create(:post) { |post| post.users_shared_by = followees.take(2) }
        end

        it "keeps the order and only shows that page" do
          expect(feed.by_score).to eq [post1]
        end
      end
    end
  end

  describe "#recent" do
    subject(:feed) { Post::Feed.new(user: user) }

    let!(:two_day_old_post) do
      Timecop.freeze(2.days.ago) do
        create(:post, tag_names: "tag1 tag2") { |post|
          post.users_shared_by << followees.first }
      end
    end

    let!(:day_old_post) do
      Timecop.freeze(1.day.ago) do
        create(:post, tag_names: "tag2") { |post|
          post.users_shared_by << followees.first }
      end
    end

    let!(:new_post) do
      create(:post, tag_names: "tag1 tag3") { |post|
        post.users_shared_by << followees.first }
    end

    let!(:non_followee_post) do
      create(:post) { |post|
        post.users_shared_by << non_followee }
    end

    it "only returns posts shared by the user's followees" do
      expect(feed.recent).to contain_exactly(new_post, day_old_post, two_day_old_post)
    end

    it "orders posts by time" do
      expect(feed.recent).to eq [new_post, day_old_post, two_day_old_post]
    end

    context "when filtering by tag" do
      subject(:feed) { Post::Feed.new(user: user, tag: "tag1") }
      it "orders posts with the tag by time" do
        expect(feed.recent).to eq [new_post, two_day_old_post]
      end
    end

    context "when filtering by page" do
      subject(:feed) { Post::Feed.new(user: user, page: 3, per_page: 1) }
      it "keeps the order and only shows that page" do
        expect(feed.recent).to eq [two_day_old_post]
      end
    end
  end
end
