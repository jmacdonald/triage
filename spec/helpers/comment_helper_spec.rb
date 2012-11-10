require 'spec_helper'

describe CommentHelper do
  describe 'embolden_mentions' do
    before(:each) do
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      @comment = FactoryGirl.create :comment
      @comment.content = "@#{@user1.username} can you talk to @#{@user2.username}?"
    end

    it 'should wrap mentions in strong tags' do
      assert_equal "<strong>@#{@user1.username}</strong> can you talk to <strong>@#{@user2.username}</strong>?", embolden_mentions(@comment.content)
    end

    it 'should return an html_safe string to prevent escaping' do
      assert embolden_mentions(@comment.content).html_safe?
    end

    it 'should escape html in the comment content' do
      @comment.content = '<html>'
      assert_equal '&lt;html&gt;', embolden_mentions(@comment.content)
    end
  end
end
