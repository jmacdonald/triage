class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def edit_profile
    authorize! :update, current_user
  end
end
