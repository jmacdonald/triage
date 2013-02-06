require 'spec_helper'

describe SettingHelper do
  describe 'display_password_form?' do
    before(:each) do
      @database_user = create :database_user
      @directory_user = create :directory_user

      # Stub current_user method.
      helper.stub(:current_user) { current_user }
    end

    context 'when not signed in' do
      let (:current_user) { nil }

      it 'returns false' do
        helper.display_password_form?.should be_false
      end
    end

    context 'when signed in as a database user' do
      let (:current_user) { @database_user }

      it 'returns true' do
        helper.display_password_form?.should be_true
      end
    end

    context 'when signed in as a directory user' do
      let (:current_user) { @directory_user }

      it 'returns false' do
        helper.display_password_form?.should be_false
      end
    end
  end
end
