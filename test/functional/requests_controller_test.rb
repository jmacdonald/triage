require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup do
    sign_in users :valid
  end

  context 'index action' do
    setup do
      get :index
    end

    should 'work' do
      assert_response :success
    end

    should 'only show the current user\'s requests' do
      assert_equal 1, assigns(:requests).count
    end

    should 'not show assignments' do
      assert_equal users(:valid), assigns(:requests).first.requester
    end
  end
end
