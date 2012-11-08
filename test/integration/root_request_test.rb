require 'test_helper'

class RootRequestTest < ActionDispatch::IntegrationTest

  context 'when the current user is an administrator' do
    setup do
      @user = users(:administrator)
      @password = 'password'
      @user.password = @password
      @user.password_confirmation = @password
      @user.save
    end
    should 'route root to unassigned requests' do 
      post_via_redirect user_session_path, 'user[username]' => @user.username, 'user[password]' => @password
      assert_equal '/', path
      assert_equal request.params[:controller], 'requests'
      assert_equal request.params[:action], 'unassigned'
    end
  end

  context 'when the current user is a provider' do
    setup do
      @user = users(:provider)
      @password = 'password'
      @user.password = @password
      @user.password_confirmation = @password
      @user.save
    end
    should 'route root to open assignments' do 
      post_via_redirect user_session_path, 'user[username]' => @user.username, 'user[password]' => @password
      assert_equal '/', path
      assert_equal request.params[:controller], 'requests'
      assert_equal request.params[:action], 'open_assignments'
    end
  end

  context 'when the current user is requester' do
    setup do
      @user = users(:requester)
      @password = 'password'
      @user.password = @password
      @user.password_confirmation = @password
      @user.save
    end
    should 'route root to open requests' do 
      post_via_redirect user_session_path, 'user[username]' => @user.username, 'user[password]' => @password
      assert_equal '/', path
      assert_equal request.params[:controller], 'requests'
      assert_equal request.params[:action], 'open'
    end
  end

  context 'when the current user is requester' do
    setup do
      @user = users(:requester)
      @password = 'password'
      @user.password = @password
      @user.password_confirmation = @password
      @user.save
    end
    should 'route root to open requests' do 
      # Commented out because CanCan config is not working for requester role
      # post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @password
      # assert_equal '/', path
      # assert_equal request.params[:controller], 'requests'
      # assert_equal request.params[:action], 'open'
    end
  end

  context 'when there is no user' do
    should 'redirect to sign in' do 
      get '/'
      assert_equal '/unauthenticated', path
      assert_equal request.params[:controller], 'requests'
      assert_equal request.params[:action], 'open'
    end
  end

end
