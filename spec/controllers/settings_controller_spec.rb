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
end
