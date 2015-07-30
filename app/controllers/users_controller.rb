class UsersController < ApplicationController
  def show
    @user                = User.find(params[:id])
    @recent_posts        = @user.recent_posts
    @recent_shared_posts = @user.recent_shared_posts
    @recent_comments     = @user.recent_comments
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Welcome!"
    else
      redirect_to :back, alert: "Your account could not be created."
    end
  end



  private
  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation
    )
  end
end
