require "rails_helper"

describe Post::Global do
  describe "#by_score" do
    subject(:global) { Post::Global.new }

    it "returns all posts" do
      posts = create_list(:post, 3)
      expect(global.by_score).to match_array posts
    end

    describe "ordering posts by the Hacker News score" do
      # score - (S - 1)/(T + 2)^1.8
      # S - number of shares
      # T - number of seconds since creation

      context "when posts are concurrent" do
        let!(:concurrent_posts) do
          Timecop.freeze(1.day.ago) do
            (0..2).map { |n|
              create(:post) { |post| post.users_shared_by = create_list(:user, n) } }
          end
        end

        it "orders by score" do
          expect(global.by_score).to eq concurrent_posts.reverse
        end
      end

      context "when posts have same number of shares" do
        let!(:equally_shared_posts) do
          (2..4).map do |n|
            Timecop.freeze(n.days.ago) do
              create(:post) { |post| post.users_shared_by = create_list(:user, 3) }
            end
          end
        end

        it "orders by time" do
          expect(global.by_score).to eq equally_shared_posts
        end
      end
    end

    context "when filtering by tag" do
      subject(:global) { Post::Global.new(tag: "tag1") }
      let!(:posts) do
        (1..3).map do |n|
          tag = n.odd? ? "tag1" : "tag2"
          create(:post, tag_names: tag) { |post| post.users_shared_by = create_list(:user, n) }
        end
      end

      it "orders posts with the tag by score" do
        expect(global.by_score).to eq [posts[2], posts[0]]
      end
    end

    context "when filtering by page" do
      subject(:global) { Post::Global.new(page: 2, per_page: 1) }

      let!(:post1) do
        create(:post) { |post| post.users_shared_by = create_list(:user, 1) }
      end

      let!(:post2) do
        create(:post) { |post| post.users_shared_by = create_list(:user, 2) }
      end

      it "keeps the order and only shows that page" do
        expect(global.by_score).to eq [post1]
      end
    end
  end

  describe "#recent" do
    let!(:two_day_old_post) do
      Timecop.freeze(2.days.ago) do
        create(:post, tag_names: "tag1 tag2")
      end
    end

    let!(:day_old_post) do
      Timecop.freeze(1.day.ago) do
        create(:post, tag_names: "tag2")
      end
    end

    let!(:new_post) { create(:post, tag_names: "tag1 tag3") }

    context "with no parameters" do
      subject(:global) { Post::Global.new }
      it "orders posts by time" do
        expect(global.recent).to eq [new_post, day_old_post, two_day_old_post]
      end
    end

    context "when filtering by tag" do
      subject(:global) { Post::Global.new(tag: "tag1") }
      it "orders posts with the tag by time" do
        expect(global.recent).to eq [new_post, two_day_old_post]
      end
    end

    context "when filtering by page" do
      subject(:global) { Post::Global.new(page: 3, per_page: 1) }
      it "keeps the order and only shows that page" do
        expect(global.recent).to eq [two_day_old_post]
      end
    end
  end
end
