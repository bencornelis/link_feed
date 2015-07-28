class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_logged_in?
    current_user != nil
  end

  helper_method :current_user
  helper_method :user_logged_in?

  private
  def authenticate_user!
    unless user_logged_in?
      redirect_to login_path, alert: "You must be logged in to do that"
    end
  end
end
