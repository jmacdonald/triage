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

  context 'a provider' do
    setup do
      @ability = Ability.new(users :provider)

      @unassigned_request = Request.new

      @assigned_request = Request.new
      @assigned_request.assignee = users :provider
    end

    should 'be able to read any request' do
      assert @ability.can?(:read, Request.new)
    end

    should 'only be able to manage requests assigned to it' do
      assert @ability.can?(:manage, @assigned_request)
      assert @ability.cannot?(:manage, @unassigned_request)
    end

    should 'not be able to destroy any requests' do
      assert @ability.cannot?(:destroy, @unassigned_request)
      assert @ability.cannot?(:destroy, @assigned_request)
    end
  end

  context 'a requester' do
    setup do
      @requester = Ability.new(users :requester)
      @owned_request = Request.new
      @owned_request.requester = users :requester
    end

    should 'be able to read its own requests' do
      assert @requester.can?(:read, @owned_request)
    end

    should 'not be able to read requests other than its own' do
      assert @requester.cannot?(:read, Request.new)
    end

    should 'be able to create requests' do
      assert @requester.can?(:create, Request.new)
    end

    should 'be able to create comments' do
      assert @requester.can?(:create, Comment.new)
    end
  end
end
