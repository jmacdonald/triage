class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :safe_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  private

  def safe_controller?
    devise_controller? or rails_admin_controller?
  end
end
