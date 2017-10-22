class FolloweesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @followees = @user.followees
  end
end