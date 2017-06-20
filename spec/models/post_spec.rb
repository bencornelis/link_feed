require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of :title }
  it { should have_many :comments }
  it { should belong_to :user }
  it { should have_many :users_shared_by }
  it { should have_many :taggings }
  it { should have_many :tags }

  it "should assign tags after being saved" do
    post = Post.new(title: "test post", tag_names: "world news")
    post.save
    expect(post.tags.map(&:name)).to eq %w(world news)
  end

  before(:each) do
    @users = (1..20).map { |n| FactoryGirl.create(:user) }
    @posts = (1..20).map { |n| FactoryGirl.create(:post) }
  end

  describe "Filter#posts" do
    it "filters posts based on tag and page (10 per page), sorts posts on shares/comments/time" do
      (0..19).each { |n| @posts[n].users_shared_by = @users[0..n] }

      @posts[2..15].each {|post| post.tags << FactoryGirl.create(:tag, name: "css")}

      filter = Post::Filter.new(tag: "css", page: 2, sort_by: "shares")
      expect(filter.posts).to eq @posts[2..5].reverse
    end
  end

  describe "Global#posts" do
    it "returns all posts matching filter params by default on first page" do
      global = Post::Global.new
      expect(global.posts.sort).to eq @posts[0..9]
    end
  end

  describe "Feed#posts" do
    it "returns all posts shared by user followees" do
      @users.zip(@posts).each { |user, post|
        user.shared_posts << post }

      user = @users.first
      user.followees += @users[5..7]

      feed = Post::Feed.new(user: user)
      expect(feed.posts.sort).to eq @posts[5..7].sort
    end
  end
end
