class ApplicationController < ActionController::Base
  include UserHelper
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  protect_from_forgery
  check_authorization :unless => :safe_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', :alert => exception.message
  end

  # Pass default parameters through strong parameter methods
  # since CanCan doesn't work with Rails 4 just yet.
  before_filter do
    resource = controller_name.singularize.to_sym
    generic_method = "#{resource}_params"
    create_method = "create_#{resource}_params"
    params[resource] &&= send(generic_method) if respond_to?(generic_method, true)
    params[resource] &&= send(create_method) if respond_to?(create_method, true)
  end

  private

  def safe_controller?
    devise_controller? || (request.path.match(/^\/admin/) && current_user.role == 'administrator')
  end
end
