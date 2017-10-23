module Posts
  class FeedsController < ApplicationController
    before_filter :reload_user_associations!

    def show
      @posts = Post::Feed.new(feed_params).posts
    end

    private

    def feed_params
      params.permit(:tag, :page, :sort).merge(user: current_user)
    end
  end
end
