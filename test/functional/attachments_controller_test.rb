require 'test_helper'


class AttachmentsControllerTest < ActionController::TestCase
  setup do
    sign_in users :valid
  end

  context 'create action' do
    setup do
      post :create, {
        :request_id => requests(:valid).id,
        :attachment => {
          title: 'New Attachment',
          file: fixture_file_upload('files/attachment.png', 'image/png')
        }
      }
    end

    should 'work' do
      assert_redirected_to request_url(id: requests(:valid).id)
    end

    should 'associate attachments with the specified request' do
      assert_equal requests(:valid).id, assigns(:attachment).request.id
    end

    should 'associate attachments with the current user' do
      assert_equal users(:valid).id, assigns(:attachment).user.id
    end
  end

  context 'delete action' do
    setup do
      delete :destroy, {
        :request_id => requests(:valid).id,
        :id => attachments(:valid).id
      }
    end

    should 'work' do
      assert_redirected_to request_url(id: requests(:valid).id)
    end

    should 'dissociate the attachment from its request' do
      assert_equal 0, requests(:valid).attachments.count
    end

    should 'destroy the attachment' do
      assert_equal 0 , Attachment.count
    end
  end
end