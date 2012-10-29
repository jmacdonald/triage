require 'test_helper'

class CommentHelperTest < ActionView::TestCase
  context 'embolden_mentions' do
    setup do
      @user1 = users :administrator
      @user2 = users :provider
      @comment = comments :valid
      @comment.content = "@#{@user1.username} can you talk to @#{@user2.username}?"
    end

    should 'embolden_mentions wraps mentions in strong tags' do
      assert_equal "<strong>@#{@user1.username}</strong> can you talk to <strong>@#{@user2.username}</strong>?", embolden_mentions(@comment.content)
    end

    should 'return an html_safe string to prevent escaping' do
      assert embolden_mentions(@comment.content).html_safe?
    end

    should 'escape html in the comment content' do
      @comment.content = '<html>'
      assert_equal '&lt;html&gt;', embolden_mentions(@comment.content)
    end
  end
end
