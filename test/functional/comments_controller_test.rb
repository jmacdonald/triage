require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    sign_in users :valid
  end

  context 'create action' do
    setup do
      post :create, { 
        request_id: requests(:valid).id,
        comment: {
          content: 'My comment'
        }
      }
    end

    should 'work' do
      assert_redirected_to request_url(id: requests(:valid).id)
    end

    should 'associate comments with the current user' do
      assert_equal users(:valid), assigns(:comment).user
    end
  end
end
