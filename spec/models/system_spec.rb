require 'spec_helper'

describe System do
  subject { FactoryGirl.build :system }

  it { should have_many :requests }
  it { should have_many :responsibilities }
  it { should have_many(:users).through(:responsibilities) }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  it 'should be able to display itself' do
    system = FactoryGirl.build :system

    system.to_s.should eq(system.name)
  end

  context 'next_assignee method' do
    before(:each) do
      # Delete all prior requests.
      Request.delete_all

      # Associate users with the system, clearing previous associations.
      @system = FactoryGirl.create :system
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      @system.users = [@user1, @user2]
      @system.save
    end

    it 'should return nil if there are no users associated with this system' do
      # Remove all users from the system.
      @system.users = []
      @system.save

      @system.next_assignee.should be_nil
    end

    it 'should return the first responsible user without any requests for this system' do
      # Assign a request for this system to the first user.
      request = FactoryGirl.build :request
      request.system = @system
      request.assignee = @user1
      request.save

      @system.next_assignee.should eq(@user2)
    end

    it 'should return the responsible user whose newest request for this system is the oldest' do
      # Assign requests to all users.
      [@user1, @user2].each do |user|
        request = FactoryGirl.build :request
        request.system = @system
        request.assignee = user
        request.save
      end

      @system.next_assignee.should eq(@user1)
    end
  end
end
