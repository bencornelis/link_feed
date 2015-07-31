class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @commentable = find_commentable
    respond_to do |format|
      format.js
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.top_level_comments.new(comment_params)
    current_user.comments << @comment
    @comment.save
    respond_to do |format|
      format.js {
        render "create_#{@comment.commentable_type.downcase}_comment"
      }
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
    params.require(:comment).permit(:text)
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
end
