require 'spec_helper'

describe SettingsController do
  before(:each) do
    @current_user = FactoryGirl.create :user, role: 'administrator'
    sign_in @current_user
  end

  describe "GET 'edit_profile'" do
    it "returns http success" do
      get 'edit_profile'
      response.should be_success
    end
  end
end
