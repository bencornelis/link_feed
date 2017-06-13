class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :reload_user_followees!, only: [:index, :show, :feed]

  def index
    @posts = Post::Global.new(filter).posts
  end

  def show
    @post = Post.includes(:comments).find(params[:id])
  end

  def new
    @post = Post.new
    2.times { @post.taggings.build.build_tag }
  end

  def edit
    @post = Post.find(params[:id])
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
    @post = Post.find(params[:id])
    authorize @post
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:id])
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
      :title, :url, :text, taggings_attributes: [:id, tag_attributes: [:id, :name]]
    )
  end

  def filter_params
    params.permit(:sort_by, :tag, :page)
  end

  def filter
    Post::Filter.new(filter_params)
  end
end
