class ProfilesController < ApplicationController
  before_filter :reload_user_followees!, only: [:show]

  def show
    @user = current_user

    respond_to do |format|
      format.html { render 'users/show' }
      format.js   { render 'users/show', format: 'js' }
    end
  end
end
