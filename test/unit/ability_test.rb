require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context 'an administrator' do
    setup do
      @ability = Ability.new(users :administrator)
    end

    should 'be able to manage any request' do
      assert @ability.can?(:manage, Request.new)
    end

    should 'be able to manage any user' do
      assert @ability.can?(:manage, User.new)
    end

    should 'be able to manage any comment' do
      assert @ability.can?(:manage, Comment.new)
    end

    should 'be able to manage any attachment' do
      assert @ability.can?(:manage, Attachment.new)
    end

    should 'be able to manage any status' do
      assert @ability.can?(:manage, Status.new)
    end
  end
end
