class FollowsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :reload_user_followees!

  def create
    followee_id = params[:user_id]
    Follow.create(followee_id: followee_id,
                  follower_id: current_user.id)
    @followee = User.find(followee_id)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    follow = Follow.find(params[:id])
    follow.destroy!
    @followee = follow.followee.reload
    respond_to do |format|
      format.js
    end
  end
end
