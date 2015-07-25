class SessionsController < ApplicationController
  def create
    @user = User.authenticate(params[:username], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to root_path, notice: "You've been logged in."
    else
      redirect_to :back, alert: "There was a problem logging you in."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You've been logged out."
  end
end
