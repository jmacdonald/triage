require 'spec_helper'

describe SettingsController do
  before(:each) do
    @current_user = FactoryGirl.create :user, role: 'administrator'
    sign_in @current_user
  end

  describe 'edit_profile' do
    it 'works' do
      get 'edit_profile'
      response.should be_success
    end
  end

  describe 'update_profile' do
    before(:each) do
      # Build a set of default permitted attributes.
      user_attributes = FactoryGirl.attributes_for(:user)
      user_attributes[:available] = true

      put :update_profile, { user: user_attributes }
    end

    it 'should work' do
      response.should be_success
    end

    describe 'strong parameters' do
      it 'should be permitted' do
        @controller.profile_params.permitted?.should be_true
      end

      describe 'permitted parameters' do
        it 'should be limited to name, email, and available' do
          @controller.profile_params.keys.should eq(['name', 'email', 'available'])
        end
      end
    end
  end

  describe 'edit_password' do
    it 'works' do
      get 'edit_password'
      response.should be_success
    end
  end

  describe 'update_password' do
    before(:each) do
      # Build a set of default permitted attributes.
      @user_attributes = FactoryGirl.attributes_for(:user)
      @user_attributes[:password_confirmation] = @user_attributes[:password]
    end

    it 'should work' do
      put :update_password, { user: @user_attributes }

      response.should be_success
      @controller.current_user.previous_changes.empty?.should be_false
    end

    it 'should confirm password' do
      # Submit password update without confirmation.
      put :update_password, { user: FactoryGirl.attributes_for(:user) }

      @controller.current_user.previous_changes.empty?.should be_true
      @controller.flash[:error].should_not be_nil
    end

    describe 'strong parameters' do
      before(:each) do
        put :update_password, { user: @user_attributes }
      end

      it 'should be permitted' do
        @controller.password_params.permitted?.should be_true
      end

      describe 'permitted parameters' do
        it 'should be limited to password and password_confirmation' do
          @controller.password_params.keys.should eq(['password'])
        end
      end
    end
  end
end
