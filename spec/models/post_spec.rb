require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of :title }
  it { should have_many :top_level_comments }
  it { should belong_to :user }
  it { should have_many :users_shared_by }
  it { should have_many :taggings }
  it { should have_many :tags }

  describe "Feed#posts" do
    it "returns all posts shared by user followees" do
      users = (1..10).map { |n| FactoryGirl.create(:user) }
      posts = (1..10).map { |n| FactoryGirl.build(:post)  }

      users.zip(posts).each { |user, post|
        user.shared_posts << post }

      user = users.first
      user.followees += users[5..7]

      filter = Post::Filter.new
      feed = Post::Feed.new(filter, user)
      expect(feed.posts.sort).to eq posts[5..7].sort
    end
  end
end
