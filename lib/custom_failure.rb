class CustomFailure < Devise::FailureApp
  def redirect_url
    login_path
  end

  def respond
    http_auth? ? http_auth : redirect
  end
end