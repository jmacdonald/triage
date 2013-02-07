require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  before(:each) do
    @administrator = create :user, role: 'administrator'
    @provider = create :user, role: 'provider'
    @requester = create :user, role: 'requester'
  end

  describe 'administrator' do
    before(:each) do
      @administrator_ability = Ability.new @administrator
    end

    it 'should be able to manage any request' do
      @administrator_ability.should be_able_to(:manage, Request.new)
    end

    it 'should be able to manage any user' do
      @administrator_ability.should be_able_to(:manage, User.new)
    end

    it 'should be able to manage any comment' do
      @administrator_ability.should be_able_to(:manage, Comment.new)
    end

    it 'should be able to manage any attachment' do
      @administrator_ability.should be_able_to(:manage, Attachment.new)
    end

    it 'should be able to manage any status' do
      @administrator_ability.should be_able_to(:manage, Status.new)
    end
  end

  describe 'provider' do
    before(:each) do
      @provider_ability = Ability.new @provider

      @assigned_request = build :request
      @assigned_request.assignee = @provider

      @admin_assigned_request = build :request
      @admin_assigned_request.assignee = @administrator

      @owned_attachment = create :attachment, { user: @provider, request: @assigned_request }
      @foreign_attachment = create :attachment, { request: @assigned_request }
    end

    it 'should be able to create new requests' do
      @provider_ability.should be_able_to(:create, Request.new)
    end

    it 'should be able to read a new request' do
      @provider_ability.should be_able_to(:read, Request.new)
    end

    it 'should be able to read a request assigned to it' do
      @provider_ability.should be_able_to(:read, @assigned_request)
    end

    it 'should be able to read a request assigned to another user' do
      @provider_ability.should be_able_to(:read, @admin_assigned_request)
    end

    it 'should not be able to update a new request' do
      @provider_ability.should_not be_able_to(:update, Request.new)
    end

    it 'should be able to update requests assigned to it' do
      @provider_ability.should be_able_to(:update, @assigned_request)
    end

    it 'should not be able to update requests assigned to another user' do
      @provider_ability.should_not be_able_to(:update, @admin_assigned_request)
    end

    it 'should not be able to destroy a new request' do
      @provider_ability.should_not be_able_to(:destroy, Request.new)
    end

    it 'should not be able to destroy a request assigned to it' do
      @provider_ability.should_not be_able_to(:destroy, @assigned_request)
    end

    it 'should not be able to destroy a request assigned to another user' do
      @provider_ability.should_not be_able_to(:destroy, @admin_assigned_request)
    end

    it 'should be able to comment on any request' do
      @provider_ability.can(:create, Comment.new)
    end

    it 'should not be able to update comments' do
      @provider_ability.should_not be_able_to(:update, Comment.new)
    end

    it 'should not be able to destroy comments' do
      @provider_ability.should_not be_able_to(:destroy, Comment.new)
    end

    it 'should be able to create attachments' do
      @provider_ability.should be_able_to(:create, Attachment.new)
    end

    it 'should be able to destroy its own attachments' do
      @provider_ability.should be_able_to(:destroy, @owned_attachment)
    end

    it 'should not be able to destroy attachments it does not own' do
      @provider_ability.should_not be_able_to(:destroy, @foreign_attachment)
    end

    it 'should be able to read itself' do
      @provider_ability.should be_able_to(:read, @provider)
    end

    it 'should not be able to read another' do
      @provider_ability.should_not be_able_to(:read, @administrator)
    end

    it 'should be able to update itself' do
      @provider_ability.should be_able_to(:update, @provider)
    end
    
    it 'should not be able to update another' do
      @provider_ability.should_not be_able_to(:update, @administrator)
    end
  end

  describe 'requester' do
    before(:each) do
      @requester_ability = Ability.new @requester

      @owned_request = build :request 
      @owned_request.requester = @requester

      @admin_request = build :request
      @admin_request.requester = @administrator

      @owned_attachment = create :attachment, { user: @requester, request: @owned_request }
      @foreign_attachment = create :attachment, { request: @owned_request }
    end

    it 'should be able to read its own requests' do
      @requester_ability.should be_able_to(:read, @owned_request)
    end

    it 'should not be able to read requests owned by another user' do
      @requester_ability.should_not be_able_to(:read, @admin_request)
    end

    it 'should be able to create requests' do
      @requester_ability.should be_able_to(:create, Request.new)
    end

    it 'should not be able to update requests' do
      @requester_ability.should_not be_able_to(:update, @owned_request)
      @requester_ability.should_not be_able_to(:update, @admin_request)
    end

    it "should be able to create comments on requests they've created" do
      comment = Comment.new
      comment.request = @owned_request
      @requester_ability.should be_able_to(:create, comment)
    end

    it "should not be able to create comments on requests they didn't create" do
      comment = Comment.new
      comment.request = @admin_request

      @requester_ability.should_not be_able_to(:create, comment)
    end

    it 'should not be able to update comments' do
      @requester_ability.should_not be_able_to(:update, @owned_request)
      @requester_ability.should_not be_able_to(:update, @admin_request)
    end

    it 'should not be able to destroy comments' do
      @requester_ability.should_not be_able_to(:destroy, @owned_request)
      @requester_ability.should_not be_able_to(:destroy, @admin_request)
    end

    it 'should not be able to create attachments on any request' do
      @requester_ability.should_not be_able_to(:create, Attachment.new)
    end

    it 'should be able to create attachments on its own requests' do
      @requester_ability.should be_able_to(:create, @owned_attachment)
    end

    it 'should be able to destroy its own attachments' do
      @requester_ability.should be_able_to(:destroy, @owned_attachment)
    end

    it 'should not be able to destroy attachments it does not own' do
      @requester_ability.should_not be_able_to(:destroy, @foreign_attachment)
    end

    it 'should be able to read itself' do
      @requester_ability.should be_able_to(:read, @requester)
    end

    it 'should not be able to read another' do
      @requester_ability.should_not be_able_to(:read, @administrator)
    end

    it 'should be able to update itself' do
      @requester_ability.should be_able_to(:update, @requester)
    end

    it 'should not be able to update another' do
      @requester_ability.should_not be_able_to(:update, @administrator)
    end
  end
end
