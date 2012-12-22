require 'spec_helper'

describe CommentsController do
  before(:each) do
    @comment_request = FactoryGirl.create :request
    sign_in user
  end

  describe 'create action' do
    # Set the user to sign in with.
    let(:user) { FactoryGirl.create :user, role: 'administrator' }

    before(:each) do
      post :create, {
        request_id: @comment_request.id,
        comment: {
          content: 'My comment'
        }
      }
    end

    it 'should work' do
      request.should redirect_to(request_url @comment_request)
    end

    it 'should associate comments with the current user' do
      assigns(:comment).user.id.should eq(user.id)
    end
  end
end
