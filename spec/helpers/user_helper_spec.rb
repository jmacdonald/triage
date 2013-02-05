require 'spec_helper'

describe UserHelper do
  before :each do
    @database_user = create :database_user
    @directory_user = create :directory_user

    # Stub out the missing devise functionality.
    helper.stub(:current_database_user) { database_user }
    helper.stub(:current_directory_user) { directory_user }
  end

  describe 'current_user' do
    context 'when logged in as a database user' do
      let(:database_user) { @database_user }
      let(:directory_user) { nil }

      it 'should return an instance of DatabaseUser' do
        helper.current_user.is_a?(DatabaseUser).should be_true
      end
    end

    context 'when logged in as a directory user' do
      let(:database_user) { nil }
      let(:directory_user) { @directory_user }

      it 'should return an instance of DatabaseUser' do
        helper.current_user.is_a?(DirectoryUser).should be_true
      end
    end
  end
end
