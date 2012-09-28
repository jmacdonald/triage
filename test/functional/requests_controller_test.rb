require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  test 'that the index action works' do
    get :index
    assert_response :success
  end
end
