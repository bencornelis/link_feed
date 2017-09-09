require "rails_helper"

describe Comment::Feed do
  describe "#comments" do
    let(:user)     { create :user_with_followees, followees_count: 1 }
    let(:followee) { user.followees.first }

    let!(:two_day_old_comment) do
      Timecop.freeze(2.days.ago) do
        create :comment, user: followee
      end
    end

    let!(:day_old_comment) do
      Timecop.freeze(1.day.ago) do
        create :comment, user: followee
      end
    end

    let!(:new_comment)      { create :comment, user: followee }
    let!(:non_feed_comment) { create :comment }

    subject(:comments) { feed.comments }

    context "by default" do
      let(:feed) { Comment::Feed.new(user: user) }

      it "returns followee comments ordered by date" do
        expect(comments.to_a)
          .to eql [new_comment, day_old_comment, two_day_old_comment]
      end
    end

    context "when filtering by page" do
      let(:feed) { Comment::Feed.new(user: user, page: 3, per_page: 1) }

      it "only shows that page" do
        expect(comments).to contain_exactly two_day_old_comment
      end
    end
  end
end
