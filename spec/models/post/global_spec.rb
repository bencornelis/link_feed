require "rails_helper"

describe Post::Global do
  describe "#posts" do
    subject(:posts) { global.posts }

    context "by default" do
      let(:global) { Post::Global.new }

      it "orders posts by Hacker News Score" do
        # score - (S - 1)/(T + 2)^1.8
        # S - number of shares
        # T - number of seconds since creation

        all_posts = []
        Timecop.freeze(1.day.ago) do
          all_posts << create(:post_with_shares, shares_count: 2)
          all_posts << create(:post_with_shares, shares_count: 1)
        end

        expect(posts.to_a).to eql all_posts
      end
    end

    context "with no parameters" do
      let(:global)     { Post::Global.new }
      let!(:all_posts) { create_list :post, 3 }

      it "returns all posts" do
        expect(posts).to match_array all_posts
      end
    end

    context "when filtering by tag" do
      let(:global) { Post::Global.new(tag: "tag1") }
      let!(:post1) { create :post, tag_names: "tag1"  }
      let!(:post2) { create :post, tag_names: "tag2"  }

      it "only includes posts with that tag" do
        expect(posts).to contain_exactly post1
      end
    end

    context "when filtering by page" do
      let(:global) { Post::Global.new(page: 2, per_page: 1) }
      before { create_list :post, 2 }

      it "only shows that page" do
        expect(posts.length).to eql 1
        expect(posts.first).to be_a Post
      end
    end

    context "when sorting by time" do
      let(:global) { Post::Global.new(sort: "time") }

      let!(:two_day_old_post) do
        Timecop.freeze(2.days.ago) { create :post }
      end

      let!(:day_old_post) do
        Timecop.freeze(1.day.ago) { create :post }
      end

      let!(:new_post) { create :post, tag_names: "tag1 tag3" }

      it "puts the most recent posts first" do
        expect(posts.to_a).to eql [new_post, day_old_post, two_day_old_post]
      end
    end
  end
end
