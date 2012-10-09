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

      @admin_assigned_request = Request.new
      @admin_assigned_request.assignee = users :administrator
    end

    should 'be able to create new requests' do
      assert @ability.can?(:create, @assigned_request)
    end

    should 'be able to read any request' do
      assert @ability.can?(:read, @unassigned_request)
      assert @ability.can?(:read, @assigned_request)
      assert @ability.can?(:read, @admin_assigned_request)
    end

    should 'only be able to update requests assigned to it' do
      assert @ability.can?(:update, @assigned_request)
      assert @ability.cannot?(:update, @admin_assigned_request)
      assert @ability.cannot?(:update, @unassigned_request)
    end

    should 'not be able to destroy any requests' do
      assert @ability.cannot?(:destroy, @unassigned_request)
      assert @ability.cannot?(:destroy, @assigned_request)
      assert @ability.cannot?(:destroy, @admin_assigned_request)
    end

    should 'be able to comment on any request' do
      assert @ability.can(:create, Comment.new)
    end

    should 'not be able to update or destroy comments' do
      assert @ability.cannot?(:update, Comment.new)
      assert @ability.cannot?(:destroy, Comment.new)
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

    should "be able to create comments on requests they've created" do
      comment = Comment.new
      comment.request = @owned_request
      assert @requester.can?(:create, comment)
    end

    should "not be able to create comments on requests they didn't create" do
      comment = Comment.new
      comment.request = requests :valid

      assert @requester.cannot?(:create, comment)
    end

    should 'not be able to update or destroy comments' do
      assert @requester.cannot?(:update, Comment.new)
      assert @requester.cannot?(:destroy, Comment.new)
    end
  end
end
