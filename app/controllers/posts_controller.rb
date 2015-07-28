class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    # redirect_to feed_path if user_logged_in?
    @posts = Post.tagged_with(params[:tag]).sort_global(params[:sort]).limit(20)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit

  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to root_path
    else
      redirect_to :back
    end
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
      :title, :url, :text, :tag1_name, :tag2_name
    )
  end

end
