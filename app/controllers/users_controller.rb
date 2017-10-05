class UsersController < ApplicationController
  before_filter :reload_user_followees!, only: [:show]

  def index
    redirect_to join_path
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
