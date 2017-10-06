require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :text }
  it { should belong_to :user }
  it { should have_many :users_shared_by }
  it { should belong_to :post }
  it { should have_many :shares }

  describe '#parent_type' do
    context 'when the comment is a root comment' do
      it 'is post' do
        comment = build_stubbed :comment, ancestry: nil

        expect(comment.parent_type).to eql :post
      end
    end

    context 'when the comment is not a root' do
      it 'is comment' do
        comment = build_stubbed :comment, ancestry: '1'

        expect(comment.parent_type).to eql :comment
      end
    end
  end

  describe '.arrange_by_score' do
    it 'sorts comments by Hacker News score' do
      day_old_comment1      = create_comment(days_ago: 1, shares: 1)
      day_old_comment2      = create_comment(days_ago: 1, shares: 2)
      two_day_old_comment   = create_comment(days_ago: 2, shares: 1)
      three_day_old_comment = create_comment(days_ago: 3, shares: 1)

      expect(Comment.arrange_by_score.keys).to eq [
        day_old_comment2,
        day_old_comment1,
        two_day_old_comment,
        three_day_old_comment
      ]
    end
  end
end
