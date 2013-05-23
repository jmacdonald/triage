class CustomFailure < Devise::FailureApp
  def redirect_url
    new_session_path
  end
end
