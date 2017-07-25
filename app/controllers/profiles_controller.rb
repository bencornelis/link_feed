class ProfilesController < ApplicationController
  before_filter :reload_user_followees!, only: [:show]

  def show
    @user                = current_user
    @recent_posts        = @user.recent_posts
    @recent_shared_posts = @user.recent_shared_posts
    @recent_comments     = @user.recent_comments
    render "users/show"
  end
end
