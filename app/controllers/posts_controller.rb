class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_post, only: [:edit, :update, :destroy]
  before_filter :reload_user_followees!, only: [:index, :show, :feed]

  def index
    @posts = Post::Global.new(filter).posts
  end

  def show
    @post = Post.includes(:comments).find(params[:id])
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
    authorize @post
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to root_path
  end

  def feed
    @posts = Post::Feed.new(filter, current_user).posts
    render :index
  end

  private

  def post_params
    params.require(:post).permit(
      :title, :url, :text, :tag1_name, :tag2_name
    )
  end

  def filter
    Post::Filter.new(filter_params)
  end

  def filter_params
    params.permit(:sort_by, :tag, :page)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
