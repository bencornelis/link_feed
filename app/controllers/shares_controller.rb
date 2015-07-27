class SharesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    Share.create(post_id: @post.id,
                 user_id: current_user.id)
    respond_to do |format|
      format.js
    end
  end
end
