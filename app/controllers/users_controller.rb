class UsersController < ApplicationController
  before_filter :reload_user_followees!, only: [:show]

  def show
    if params[:id]
      @user = User.includes({:followers => :roles}, {:followees => :roles}).find(params[:id])
    else
      @user = current_user
    end

    @recent_posts        = @user.recent_posts.includes(:tags)
    @recent_shared_posts = @user.recent_shared_posts.includes(:tags, {:user => :roles})
    @recent_comments     = @user.recent_comments.includes({:post => {:user => :roles}})
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome!"
    else
      redirect_to :back, alert: "Your account could not be created."
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :id
    )
  end
end
