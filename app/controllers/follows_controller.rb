class FollowsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @followee = User.find(params[:user_id])
    Follow.create(followee_id: @followee.id,
                  follower_id: current_user.id)
    respond_to do |format|
      format.js
    end
  end

end
