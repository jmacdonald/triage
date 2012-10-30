class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :safe_controller?
  
  private
  def safe_controller?
    devise_controller? or rails_admin_controller?
  end
end
