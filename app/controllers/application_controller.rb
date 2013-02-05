class ApplicationController < ActionController::Base
  include UserHelper
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
end
