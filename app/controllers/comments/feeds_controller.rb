module Comments
  class FeedsController < ApplicationController
    before_filter :reload_user_followees!

    def show
      @comments = Comment::Feed.new(feed_params).comments
    end

    private

    def feed_params
      params.permit(:tag, :page, :sort).merge(user: current_user)
    end
  end
end
