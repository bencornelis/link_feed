class ProfilesController < ApplicationController
  before_filter :reload_user_followees!, only: [:show]

  def show
    @user = current_user
    render "users/show"
  end
end
