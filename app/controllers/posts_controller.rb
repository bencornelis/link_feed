class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :recent, :show]
  before_filter :reload_user_followees!, only: [:index, :recent, :show, :feed]

  def index
    @posts = Post::Global.new(global_params).posts
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.js do
        @comments = @post.comments.arrange(order: "created_at asc")
      end
    end
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    authorize @post
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      current_user.shared_posts << @post
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

  private

  def post_params
    params.require(:post).permit(:title, :url, :text, :tag_names)
  end

  def global_params
    params.permit(:tag, :page, :sort)
  end
end
