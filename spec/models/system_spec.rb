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

  describe 'next_assignee method' do
    before(:each) do
      # Delete all prior requests.
      Request.delete_all

      # Create a system.
      @system = FactoryGirl.create :system
    end

    context 'when no users are responsible for this system' do
      it 'should always return nil' do
        @system.next_assignee.should be_nil
      end
    end

    context 'when there are multiple users responsible for this system' do
      before(:each) do
        # Associate users with the system.
        @user1 = FactoryGirl.create :user
        @user2 = FactoryGirl.create :user
        @system.users = [@user1, @user2]
        @system.save
      end

      context 'when only one of the users has had a request assigned to it' do
        before :each do
          # Assign a request for this system to the first user.
          request = FactoryGirl.build :request
          request.system = @system
          request.assignee = @user1
          request.save
        end

        it 'should return the first responsible user without any requests for this system' do
          @system.next_assignee.should eq(@user2)
        end

        it 'should return the first user if the second is unavailable' do
          # Set the second user as unavailable.
          @user2.available = false
          @user2.save

          @system.next_assignee.should eq(@user1)
        end

        it 'should not return anything when all users are unavailable' do
          # Set all of the users to unavailable.
          @user1.available = false
          @user2.available = false
          @user1.save
          @user2.save

          @system.next_assignee.should be_nil
        end
      end

      context 'when assigned users have all been assigned a request for it at some point' do
        before(:each) do
          # Assign requests to all users.
          [@user1, @user2].each do |user|
            request = FactoryGirl.build :request
            request.system = @system
            request.assignee = user
            request.save
          end
        end

        it 'should return the responsible user whose newest request for this system is the oldest' do
          @system.next_assignee.should eq(@user1)
        end

        it 'should return the second user if the first is unavailable' do
          # Set the first user as unavailable.
          @user1.available = false
          @user1.save

          @system.next_assignee.should eq(@user2)
        end

        it 'should not return anything when all users are unavailable' do
          # Set all of the users to unavailable.
          @user1.available = false
          @user2.available = false
          @user1.save
          @user2.save

          @system.next_assignee.should be_nil
        end
      end
    end
  end
end
