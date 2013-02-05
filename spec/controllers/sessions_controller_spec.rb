require 'spec_helper'

describe SessionsController do
  before(:each) do
    @password = 'testpassword'
    @user = FactoryGirl.create :user, role: 'administrator', password: @password
    @request.env['devise.mapping'] = Devise.mappings[:database_user]
  end

  describe 'new' do
    it 'should work' do
      get :new
      response.should be_success
    end
  end

  describe 'create' do
    context 'with invalid credentials' do
      before(:each) do
        post :create, {
          user: {
            username: 'asdf',
            password: 'asdf'
          }
        }
      end

      it 'should redirect to new action' do
        response.should redirect_to(new_session_path)
      end
    end

    context 'with valid credentials' do
      before(:each) do
        post :create, {
          user: {
            username: @user.username,
            password: @password
          }
        }
      end

      it 'should work' do
        response.should be_redirect
      end

      it 'should redirect to the root path' do
        response.should redirect_to(root_path)
      end

      it 'should sign the user in' do
        @controller.database_user_signed_in?.should be_true
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      # Create the session.
      post :create, {
        user: {
          username: @user.username,
          password: @password
        }
      }

      # Destroy the session.
      delete :destroy
    end

    it 'should work' do
      response.should be_redirect
    end

    it 'should redirect to the new action' do
      response.should redirect_to(new_session_path)
    end

    it 'should sign the user out' do
      @controller.database_user_signed_in?.should be false
    end
  end
end
