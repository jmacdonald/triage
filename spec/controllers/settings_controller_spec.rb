require 'spec_helper'

describe SettingsController do

  describe "GET 'edit_profile'" do
    it "returns http success" do
      get 'edit_profile'
      response.should be_success
    end
  end

end
