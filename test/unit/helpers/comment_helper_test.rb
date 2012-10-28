require 'test_helper'

class CommentHelperTest < ActionView::TestCase
  context 'embolden_mentions' do
    setup do
      @user1 = users :administrator
      @user2 = users :provider
      @comment = comments :valid
    end

    should 'embolden_mentions wraps mentions in strong tags' do
      @comment.content = "@#{@user1.username} can you talk to @#{@user2.username}?"

      assert_equal "<strong>@#{@user1.username}</strong> can you talk to <strong>@#{@user2.username}</strong>?", embolden_mentions(@comment.content)
    end
  end
end
