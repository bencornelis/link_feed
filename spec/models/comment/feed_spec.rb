require "rails_helper"

describe Comment::Feed do
  describe "#comments" do
    let!(:followee)     { create(:user) }
    let!(:non_followee) { create(:user) }

    let!(:user) do
      create(:user) { |user|
        user.followees << followee }
    end

    let!(:post) do
      Timecop.freeze(3.days.ago) { create(:post) }
    end

    let!(:two_day_old_comment) do
      Timecop.freeze(2.days.ago) do
        create(:comment) do |comment|
          comment.user = followee
          post.comments << comment
        end
      end
    end

    let!(:day_old_comment) do
      Timecop.freeze(1.day.ago) do
        create(:comment) do |comment|
          comment.user = followee
          post.comments << comment
        end
      end
    end

    let!(:new_comment) do
      create(:comment) do |comment|
        comment.user = followee
        post.comments << comment
      end
    end

    let!(:non_feed_comment) do
      create(:comment) do |comment|
        comment.user = non_followee
        post.comments << comment
      end
    end

    subject(:feed) { Comment::Feed.new(user: user) }

    it "only includes comments by followees" do
      expect(feed.comments).to include new_comment, day_old_comment, two_day_old_comment
      expect(feed.comments).not_to include non_feed_comment
    end

    it "orders followee comments by date" do
      expect(feed.comments).to eq [new_comment, day_old_comment, two_day_old_comment]
    end

    context "when filtering by page" do
      subject(:feed) { Comment::Feed.new(user: user, page: 3, per_page: 1) }
      it "only shows that page" do
        expect(feed.comments).to eq [two_day_old_comment]
      end
    end
  end
end
