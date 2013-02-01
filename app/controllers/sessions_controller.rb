class SessionsController < Devise::SessionsController
  def create
    # Copy the generic "user" parameters into the more specific subclasses.
    params['directory_user'] = params['database_user'] = params['user']

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
end
