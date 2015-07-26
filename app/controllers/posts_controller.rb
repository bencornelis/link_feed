class PostsController < ApplicationController
  def index
    # redirect_to feed_path if user_logged_in?

    @post = Post.all
  end

  def show

  end

  def new
    @post = Post.new
  end

  def edit

  end

  def create
    @post = Post.new(post_params)
  end

  def update

  end

  def destroy

  end

  def feed

  end

  private
  def post_params
    params.require(:post).permit(
      :title, :url, :text
    )
  end

end
