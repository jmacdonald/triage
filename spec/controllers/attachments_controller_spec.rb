require 'spec_helper'

describe AttachmentsController do
  before(:each) do
    @attachment_request = create :request
    @user = create :database_user
    sign_in @user
  end

  describe 'create action' do
    before(:each) do
      post :create, {
        request_id: @attachment_request.id,
        attachment: {
          title: 'New Attachment',
          file: fixture_file_upload("/attachment.png")
        }
      }
    end

    it 'should work' do
      response.should redirect_to(request_url(id: @attachment_request.id))
    end

    it 'should associate attachments with the specified request' do
      assigns(:attachment).request.id.should eq(@attachment_request.id)
    end

    it 'should associate attachments with the current user' do
      assigns(:attachment).user.id.should eq(@user.id)
    end

    it 'should only allow title and file to be set' do
      @controller.attachment_params.keys.should eq(['title', 'file'])
    end
  end

  context 'delete action' do
    before(:each) do
      attachment = create :attachment, request: @attachment_request, user: @user
      delete :destroy, {
        request_id: @attachment_request.id,
        id: attachment.id
      }
    end

    it 'should work' do
      response.should redirect_to(request_url(id: @attachment_request.id))
    end

    it 'should dissociate the attachment from its request' do
      @attachment_request.attachments.count.should eq(0)
    end

    it 'should destroy the attachment' do
      Attachment.count.should eq(0)
    end
  end
end
