require 'spec_helper'

describe CommentHelper do
  before(:each) do
    @foreign_request = FactoryGirl.create :request

    @user1 = FactoryGirl.create :user
    @user2 = FactoryGirl.create :user

    @comment = FactoryGirl.create :comment
    @comment.content = content
  end

  describe 'escape' do
    let (:content) { '<html>' }

    it 'should escape html in the comment content' do
      assert_equal '&lt;html&gt;', escape(@comment.content)
    end

    it 'should return an html_safe string to prevent escaping' do
      assert escape(@comment.content).html_safe?
    end
  end

  describe 'embolden_mentions' do
    let(:content) { "@#{@user1.username} can you talk to @#{@user2.username}?" }

    it 'should wrap mentions in strong tags' do
      assert_equal "<strong>@#{@user1.username}</strong> can you talk to <strong>@#{@user2.username}</strong>?", embolden_mentions(@comment.content)
    end
  end

  describe 'link_references' do
    context 'with a valid reference' do
      let(:content) { "This issue is related to ##{@foreign_request.id}." }

      it 'should insert links' do
        link_references(@comment.content).should eq("This issue is related to <a href=\"#{request_path(@foreign_request)}\">##{@foreign_request.id}</a>.")
      end
    end

    context 'with an invalid reference' do
      let(:content) { "This issue is related to #asdf." }

      it 'should not insert links' do
        link_references(@comment.content).should eq(@comment.content)
      end
    end
  end
end
