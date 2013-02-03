class SessionsController < Devise::SessionsController
  def create
    # Move the user parameters into their subclass variants. Modifying the
    # rack request parameters directly as Warden operates at a lower level.
    request.params['directory_user'] = request.params['database_user'] = request.params['user']
    request.params.delete('user')

    # Try to authenticate as a directory user.
    user_class = :directory_user
    self.resource = warden.authenticate scope: user_class

    if self.resource.nil?
      # Directory user authentication failed; force database user authentication.
      user_class = :database_user
      self.resource = warden.authenticate! scope: user_class
    end

    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(user_class, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  def destroy
    set_flash_message :notice, :signed_out if sign_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to new_database_user_session_path }
    end
  end
end
