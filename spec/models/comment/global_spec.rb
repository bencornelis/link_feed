require "rails_helper"

describe Comment::Global do
  describe "#comments" do
    let!(:day_old_comment1)      { create_comment(days_ago: 1, shares: 1) }
    let!(:day_old_comment2)      { create_comment(days_ago: 1, shares: 2) }
    let!(:day_old_comment3)      { create_comment(days_ago: 1, shares: 0, badgings: 2) }
    let!(:two_day_old_comment)   { create_comment(days_ago: 2, shares: 1) }
    let!(:three_day_old_comment) { create_comment(days_ago: 3, shares: 1) }

    subject(:comments) { global.comments }

    context "by default" do
      let(:global) { Comment::Global.new }

      it "orders comments by Hacker News score" do
        # badges are weighted more than shares

        expect(comments).to eq [
          day_old_comment3,
          day_old_comment2,
          day_old_comment1,
          two_day_old_comment,
          three_day_old_comment
        ]
      end
    end

    context "when filtering by page" do
      let(:global) { Comment::Global.new(page: 4, per_page: 1) }

      it "only shows that page" do
        expect(comments).to contain_exactly two_day_old_comment
      end
    end
  end
end
