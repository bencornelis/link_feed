require "rails_helper"

describe Comment::Global do
  describe "#comments" do
    let!(:two_day_old_comment) do
      Timecop.freeze(2.days.ago) { create :comment }
    end

    let!(:day_old_comment) do
      Timecop.freeze(1.day.ago) { create :comment }
    end

    let!(:new_comment) { create :comment }

    subject(:comments) { global.comments }

    context "by default" do
      let(:global) { Comment::Global.new }

      it "orders the comments by date" do
        expect(comments.to_a)
          .to eql [new_comment, day_old_comment, two_day_old_comment]
      end
    end

    context "when filtering by page" do
      let(:global) { Comment::Global.new(page: 3, per_page: 1) }

      it "only shows that page" do
        expect(comments).to contain_exactly two_day_old_comment
      end
    end
  end
end
