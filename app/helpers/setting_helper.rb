module SettingHelper
  def display_password_form?
    current_user.is_a? DatabaseUser
  end
end
