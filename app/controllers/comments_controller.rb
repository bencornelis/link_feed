class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @parent_id = params.delete(:parent_id)
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(parent_id: @parent_id)
    respond_to do |format|
      format.js
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    current_user.comments << @comment
    @comment.save
    respond_to do |format|
      format.js do
        if @comment.root?
          render :create_post_comment
        else
          render :create_comment_comment
        end
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize comment
    comment.destroy
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit(:text, :parent_id)
  end
end
