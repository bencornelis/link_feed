class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :reload_user_followees!, only: [:index, :show, :feed]

  def index
    @posts = Post::Global.new(filter_params).posts
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes({user: :roles}).arrange(order: "created_at asc")
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_path(@post)
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
    @posts = Post::Feed.new(filter_params).posts
    render :index
  end

  private

  def post_params
    params.require(:post).permit(
      :title, :url, :text, :tag_names
    )
  end

  def filter_params
    params.permit(:sort_by, :tag, :page).merge({user: current_user})
  end
end
