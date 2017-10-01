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

    respond_to do |format|
      format.js do
        if @user.save
          session[:user_id] = @user.id
          flash[:notice] = 'Welcome!'
          render :js => "window.location = '#{root_path}'"
        else
          flash[:alert] = 'Your account could not be created.'
        end
      end
    end
  end

  private

  def user_params
    params.require(:user)
      .permit(:username, :email, :password, :password_confirmation, :id)
  end
end
