class FollowsController < ApplicationController
  before_filter :authenticate_user!

  def create
    followee_id = params[:user_id]
    Follow.create(followee_id: followee_id,
                  follower_id: current_user.id)
    @followee = User.find(followee_id)
    respond_to do |format|
      format.js
    end
  end

end
