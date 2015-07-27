class FollowsController < ApplicationController
  before_filter :authenticate_user!

  def create
    Follow.create(followee_id: params[:user_id],
                  follower_id: current_user.id)
    redirect_to :back
  end
end
