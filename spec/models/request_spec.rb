require 'spec_helper'

describe Request do
  subject { FactoryGirl.create :request }

  it { should belong_to :requester }
  it { should belong_to :assignee }
  it { should belong_to :status }
  it { should belong_to :system }
  it { should have_many :comments }
  it { should have_many :attachments }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :requester }
  it { should validate_presence_of :system }
  it { should validate_presence_of :severity }
  it { should ensure_inclusion_of(:severity).in_array %w(minor moderate major critical) }

  [:assignee_id, :status_id, :system_id, :title, :description, :severity, :requester_id].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end

  it 'should be able to display itself as a string' do
    subject.to_s.should eq("Request ##{subject.id}: #{subject.title}")
  end

  context 'status' do
    before(:each) do
      @default_status = FactoryGirl.create :status, default: true 
    end

    it 'should be set to the default status' do
      subject.status = nil
      subject.save
      
      subject.reload.status.default?.should be_true
    end

    it 'should be preserved when explicitly set' do
      closed_status = FactoryGirl.create :status, closed: true
      subject.status = closed_status
      subject.save

      subject.reload.status.closed?.should be_true
    end
  end

  describe 'scopes' do
    before(:each) do
      # Create both closed and open statuses.
      @open_status = FactoryGirl.create :status, closed: false
      @closed_status = FactoryGirl.create :status, closed: true

      # Create a request for the closed and open statuses.
      @open_request = FactoryGirl.create :request, status: @open_status
      @closed_request = FactoryGirl.create :request, status: @closed_status
    end

    describe 'closed scope' do
      it 'should return the right number of requests' do
        Request.closed.count.should eq(1)
      end

      it 'should only return requests with statuses that are closed' do
        Request.closed.each do |request|
          request.status.closed?.should be_true
        end
      end
    end

    describe 'unclosed scope' do
      it 'should return the right number of requests' do
        Request.unclosed.count.should eq(1)
      end

      it 'should only return requests with statuses that are open' do
        Request.unclosed.each do |request|
          request.status.closed?.should be_false
        end
      end
    end

    describe 'unassigned scope' do
      before(:each) do
        # Create an assigned request.
        provider = FactoryGirl.create :user, role: 'provider'
        FactoryGirl.create :request, assignee: provider
      end

      it 'should return the right number of requests' do
        Request.unassigned.count.should eq(2)
      end

      it 'should only return requests without an assignee' do
        Request.unassigned.each do |request|
          request.assignee.should be_nil
        end
      end
    end
  end

  describe 'assignee association' do
    before(:each) do
      @request = FactoryGirl.build :request
    end

    it 'should allow administrators to be associated' do
      administrator = FactoryGirl.create :user, role: 'administrator'
      @request.assignee = administrator
      @request.save

      @request.assignee.should_not be_nil
    end

    it 'should allow providers to be associated' do
      @request.assignee = FactoryGirl.create :user, role: 'provider'
      @request.save

      @request.assignee.should_not be_nil
    end

    it 'should not allow requesters to be associated' do
      @request.assignee = FactoryGirl.create :user, role: 'requester'
      @request.save

      @request.reload.assignee.should be_nil
    end
  end

  describe 'auto-assignment' do
    it 'should assign new requests to the next user responsible for its system' do
      # Create a system with a responsible user.
      responsible_user = FactoryGirl.create :user, role: 'provider'
      system = FactoryGirl.create :system, users: [responsible_user]

      # Create a request for the system with a responsible user.
      request = FactoryGirl.create :request, system: system

      request.assignee.id.should eq(responsible_user.id)
    end
  end
end
