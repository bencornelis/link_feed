class UsersController < ApplicationController
  before_filter :reload_user_followees!, only: [:show]

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
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
    params.require(:user)
      .permit(:username, :email, :password, :password_confirmation, :id)
  end
end
