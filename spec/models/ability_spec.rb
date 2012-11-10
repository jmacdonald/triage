require 'spec_helper'

describe Ability do
  before(:each) do
    @administrator = FactoryGirl.create :user, role: 'administrator'
    @provider = FactoryGirl.create :user, role: 'provider'
    @requester = FactoryGirl.create :user, role: 'requester'
  end

  context 'an administrator' do
    before(:each) do
      @administrator_ability = Ability.new @administrator
    end

    it 'should be able to manage any request' do
      @administrator_ability.can?(:manage, Request.new).should be_true
    end

    it 'should be able to manage any user' do
      @administrator_ability.can?(:manage, User.new).should be_true
    end

    it 'should be able to manage any comment' do
      @administrator_ability.can?(:manage, Comment.new).should be_true
    end

    it 'should be able to manage any attachment' do
      @administrator_ability.can?(:manage, Attachment.new).should be_true
    end

    it 'should be able to manage any status' do
      @administrator_ability.can?(:manage, Status.new).should be_true
    end
  end

  context 'a provider' do
    before(:each) do
      @provider_ability = Ability.new @provider

      @assigned_request = FactoryGirl.build :request
      @assigned_request.assignee = @provider

      @admin_assigned_request = FactoryGirl.build :request
      @admin_assigned_request.assignee = @administrator
    end

    it 'should be able to create new requests' do
      @provider_ability.can?(:create, Request.new).should be_true
    end

    it 'should be able to read a new request' do
      @provider_ability.can?(:read, Request.new).should be_true
    end

    it 'should be able to read a request assigned to it' do
      @provider_ability.can?(:read, @assigned_request).should be_true
    end

    it 'should be able to read a request assigned to another user' do
      @provider_ability.can?(:read, @admin_assigned_request).should be_true
    end

    it 'should not be able to update a new request' do
      @provider_ability.cannot?(:update, Request.new).should be_true
    end

    it 'should be able to update requests assigned to it' do
      @provider_ability.can?(:update, @assigned_request).should be_true
    end

    it 'should not be able to update requests assigned to another user' do
      @provider_ability.cannot?(:update, @admin_assigned_request).should be_true
    end

    it 'should not be able to destroy a new request' do
      @provider_ability.cannot?(:destroy, Request.new).should be_true
    end

    it 'should not be able to destroy a request assigned to it' do
      @provider_ability.cannot?(:destroy, @assigned_request).should be_true
    end

    it 'should not be able to destroy a request assigned to another user' do
      @provider_ability.cannot?(:destroy, @admin_assigned_request).should be_true
    end

    it 'should be able to comment on any request' do
      @provider_ability.can(:create, Comment.new).should be_true
    end

    it 'should not be able to update comments' do
      @provider_ability.cannot?(:update, Comment.new).should be_true
    end

    it 'should not be able to destroy comments' do
      @provider_ability.cannot?(:destroy, Comment.new).should be_true
    end
  end

  context 'a requester' do
    before(:each) do
      @requester_ability = Ability.new @requester

      @owned_request = FactoryGirl.build :request 
      @owned_request.requester = @requester

      @admin_request = FactoryGirl.build :request
      @admin_request.requester = @administrator
    end

    it 'should be able to read its own requests' do
      @requester_ability.can?(:read, @owned_request).should be_true
    end

    it 'should not be able to read requests owned by another user' do
      @requester_ability.cannot?(:read, @admin_request).should be_true
    end

    it 'should be able to create requests' do
      @requester_ability.can?(:create, Request.new).should be_true
    end

    it 'should not be able to update requests' do
      @requester_ability.cannot?(:update, @owned_request).should be_true
      @requester_ability.cannot?(:update, @admin_request).should be_true
    end

    it "should be able to create comments on requests they've created" do
      comment = Comment.new
      comment.request = @owned_request
      @requester_ability.can?(:create, comment).should be_true
    end

    it "should not be able to create comments on requests they didn't create" do
      comment = Comment.new
      comment.request = @admin_request

      @requester_ability.cannot?(:create, comment).should be_true
    end

    it 'should not be able to update comments' do
      @requester_ability.cannot?(:update, @owned_request).should be_true
      @requester_ability.cannot?(:update, @admin_request).should be_true
    end

    it 'should not be able to destroy comments' do
      @requester_ability.cannot?(:destroy, @owned_request).should be_true
      @requester_ability.cannot?(:destroy, @admin_request).should be_true
    end
  end
end
