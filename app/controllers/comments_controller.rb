class CommentsController < ApplicationController

  def new
    @commentable = find_commentable
    respond_to do |format|
      format.js {
        unless user_logged_in?
          flash[:alert] = "You must be logged in to do that"
          render :js => "window.location = '#{login_path}'"
        end
      }
    end
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.new(comment_params)
    current_user.comments << @comment
    @comment.save
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
