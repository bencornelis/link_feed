require "rails_helper"

describe Post::Global do
  describe "#posts" do
    subject(:global) { Post::Global.new }

    it "returns all posts" do
      posts = create_list(:post, 3)
      expect(global.posts).to match_array posts
    end

    it "orders posts by Hacker News Score by default" do
      # score - (S - 1)/(T + 2)^1.8
      # S - number of shares
      # T - number of seconds since creation

      posts = []
      Timecop.freeze(1.day.ago) do
        2.times do |i|
          posts << create(:post) { |post|
            post.users_shared_by = create_list(:user, i+1) }
        end
      end

      expect(global.posts).to eq posts.reverse
    end

    context "when filtering by tag" do
      subject(:global) { Post::Global.new(tag: "tag1") }
      let!(:post1) { create(:post, tag_names: "tag1") }
      let!(:post2) { create(:post, tag_names: "tag2") }

      it "only includes posts with that tag" do
        expect(global.posts).to contain_exactly post1
      end
    end

    context "when filtering by page" do
      subject(:global) { Post::Global.new(page: 2, per_page: 1) }
      let!(:posts) { create_list(:post, 2) }

      it "only shows that page" do
        expect(global.posts.length).to eq 1
      end
    end

    context "when sorting by time" do
      subject(:global) { Post::Global.new(sort: "time") }

      let!(:two_day_old_post) do
        Timecop.freeze(2.days.ago) { create(:post) }
      end

      let!(:day_old_post) do
        Timecop.freeze(1.day.ago) { create(:post) }
      end

      let!(:new_post) { create(:post, tag_names: "tag1 tag3") }

      it "puts the most recent posts first" do
        expect(global.posts).to eq [new_post, day_old_post, two_day_old_post]
      end
    end
  end
end
