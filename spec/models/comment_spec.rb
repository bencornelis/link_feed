require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :text }
  it { should belong_to :user }
  it { should belong_to :post }

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
end
