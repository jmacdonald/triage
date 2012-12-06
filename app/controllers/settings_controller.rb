class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def edit_profile
    authorize! :update, current_user
  end

  def update_profile
    authorize! :update, current_user

    if current_user.update_attributes params[:user]
      flash[:notice] = t 'settings.update_profile.success'
    end

    render 'edit_profile'
  end
end
