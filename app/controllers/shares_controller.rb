class SharesController < ApplicationController
  def create
    Share.create(post_id: params[:post_id],
                 user_id: current_user.id)
    @post = Post.find(params[:post_id])
    respond_to do |format|
      format.js
    end
  end
end
