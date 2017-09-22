class CommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_filter :reload_user_followees!, only: [:index]

  def index
    @comments = Comment::Global.new(global_params).comments
  end

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
    authorize @comment
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
      format.js { render "create_#{@comment.parent_type}_comment" }
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    authorize @comment
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

  def global_params
    params.permit(:tag, :page)
  end

  def comment_params
    params.require(:comment).permit(:text, :parent_id)
  end
end
