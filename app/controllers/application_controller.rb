class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_logged_in?
    current_user.present?
  end

  helper_method :current_user
  helper_method :user_logged_in?

  private

  def authenticate_user!
    unless user_logged_in?
      flash[:alert] = "You must be logged in to do that."
      respond_to do |format|
        format.html { redirect_to login_path }
        format.js { render :js => "window.location = '#{login_path}'" }
      end
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def reload_user_followees!
    return unless user_logged_in?
    @current_user = User.includes(:followees => :roles).find(session[:user_id])
  end
end
