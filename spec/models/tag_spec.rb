require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should have_many :taggings }
  it { should have_many :posts }

  describe '.recent' do
    it 'returns the most recent tags, in descending order' do
      tag1 = create :tag
      tag2 = create :tag
      tag3 = create :tag

      expect(described_class.recent(2)).to eq [tag3, tag2]
    end
  end

  describe '.popular' do
    it 'returns the most popular tags, in descending order' do
      tag1 = create :tag, posts_count: 2
      tag2 = create :tag, posts_count: 1
      tag3 = create :tag, posts_count: 3

      expect(described_class.popular(2)).to eq [tag3, tag1]
    end
  end

  describe '#with_hash' do
    context 'when the tag has a hash' do
      it 'does not change the tag' do
        tag = build :tag, name: '#foo'

        expect(tag.with_hash).to eql '#foo'
      end
    end

    context 'when the tag does not have a hash' do
      it 'puts a hash in front' do
        tag = build :tag, name: 'bar'

        expect(tag.with_hash).to eql '#bar'
      end
    end
  end
end
