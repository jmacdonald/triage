require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup do
    sign_in users :valid
  end

  test 'that the index action works' do
    get :index
    assert_response :success
  end
end
