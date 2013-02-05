class ApplicationController < ActionController::Base
  helper_method :current_user
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  protect_from_forgery
  check_authorization :unless => :safe_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def safe_controller?
    devise_controller? || (request.path.match(/^\/admin/) && current_user.role == 'administrator')
  end

  def authenticate_user!
    # We can't just call authenticate_directory/database_user directly; if we're authenticated with one and we
    # call the other, we'll be logged out.
    if directory_user_signed_in?
      authenticate_directory_user!
    else
      authenticate_database_user!
    end
  end

  def current_user
    current_directory_user or current_database_user
  end
end
