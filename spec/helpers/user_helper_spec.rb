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
    context 'when signed in as a database user' do
      let(:database_user) { @database_user }
      let(:directory_user) { nil }

      it 'should return an instance of DatabaseUser' do
        helper.current_user.is_a?(DatabaseUser).should be_true
      end
    end

    context 'when signed in as a directory user' do
      let(:database_user) { nil }
      let(:directory_user) { @directory_user }

      it 'should return an instance of DatabaseUser' do
        helper.current_user.is_a?(DirectoryUser).should be_true
      end
    end
  end

  describe 'authenticate_user!' do
    before :each do
      # Stub out the missing devise functionality.
      helper.stub(:database_user_signed_in?) { database_user_signed_in }
      helper.stub(:directory_user_signed_in?) { directory_user_signed_in }
      helper.stub(:authenticate_database_user!) { helper.database_user_signed_in? }
      helper.stub(:authenticate_directory_user!) { helper.directory_user_signed_in? }
    end

    context 'when not signed in' do
      let(:database_user_signed_in) { false }
      let(:directory_user_signed_in) { false }

      it 'should return false' do
        helper.authenticate_user!.should be_false
      end
    end

    context 'when signed in as a database user' do
      let(:database_user_signed_in) { true }
      let(:directory_user_signed_in) { false }

      it 'should return true' do
        helper.authenticate_user!.should be_true
      end
    end

    context 'when signed in as a directory user' do
      let(:database_user_signed_in) { false }
      let(:directory_user_signed_in) { true }

      it 'should return true' do
        helper.authenticate_user!.should be_true
      end
    end
  end
end
