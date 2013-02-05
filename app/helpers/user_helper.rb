module UserHelper
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
