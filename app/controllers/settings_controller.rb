class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def edit_profile
    authorize! :update, current_user
  end

  def update_profile
    authorize! :update, current_user

    if current_user.update_attributes profile_params
      flash.now[:notice] = t 'settings.update_profile.success'
    end

    render 'edit_profile'
  end

  def edit_password
    authorize! :update, current_user
  end

  def update_password
    authorize! :update, current_user

    # Confirm password.
    if params[:user][:password] != params[:user][:password_confirmation]
      flash.now[:error] = t 'settings.update_password.mismatch'
    elsif current_user.update_attributes password_params
      flash.now[:notice] = t 'settings.update_password.success'
    end

    render 'edit_password'
  end

  def profile_params
    return params.require(:user).permit(:name, :email, :available)
  end

  def password_params
    return params.require(:user).permit(:password, :password_confirmation)
  end
end
