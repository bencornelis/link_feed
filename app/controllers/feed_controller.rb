class FeedController < ApplicationController
  before_filter :reload_user_followees!

  def index
    @posts = Post::Feed.new(feed_params).by_score
  end

  def recent
    @posts = Post::Feed.new(feed_params).recent
    render :index
  end

  def comments
    @comments = Comment::Feed.new(feed_params).recent
  end

  private
  def feed_params
    params.permit(:tag, :page).merge({user: current_user})
  end
end
