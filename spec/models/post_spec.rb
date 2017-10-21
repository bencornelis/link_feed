require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of :title }
  it { should have_many :comments }
  it { should belong_to :user }
  it { should have_many :users_shared_by }
  it { should have_many :taggings }
  it { should have_many :tags }

  it "should assign tags after being saved" do
    post = build :post, tag_names: %w(world news)
    post.save!

    tags = post.reload.tags
    expect(tags.pluck(:name)).to match_array %w(world news)
  end

  describe "#text_only?" do
    context "when the post has a url" do
      let(:post) { build_stubbed :post, url: "https://www.google.com/" }

      it "is false" do
        expect(post.text_only?).to be false
      end
    end

    context "when the post doesn't have a url" do
      let(:post) { build_stubbed :post }

      it "is true" do
        expect(post.text_only?).to be true
      end
    end
  end
end
