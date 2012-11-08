require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  subject { systems :valid }

  should have_many :requests
  should have_many :responsibilities
  should have_many(:users).through(:responsibilities)
  should validate_presence_of :name
  should validate_uniqueness_of :name

  test 'that a system can display itself' do
    assert_equal 'Triage', systems(:valid).to_s
  end

  context 'next_assignee method' do
    setup do
      # Remove any pre-existing requests; these can affect our tests.
      Request.delete_all

      # Define options to quickly generate requests.
      @common_options = {
        title: 'Test Request',
        description: 'This is a test.',
        requester_id: users(:requester).id,
        system_id: systems(:valid).id,
        severity: 'minor'
      }

      # Associate users with the system, clearing previous associations.
      @system = systems :valid
      @system.users = [users(:administrator), users(:provider)]
      @system.save
    end

    should 'return nil if there are no users associated with this system' do
      # Remove all users from the system.
      @system.users = []
      @system.save

      assert_equal nil, @system.next_assignee
    end

    should 'return the first responsible user without any requests for this system' do
      # Assign a request to the admin.
      request = Request.new @common_options
      request.assignee = users :administrator
      request.save

      assert_equal users(:provider), @system.next_assignee
    end

    should 'return the responsible user whose newest request for this system is the oldest' do
      # Assign a request to the admin.
      request = Request.new @common_options
      request.assignee = users :administrator
      request.save

      # Assign a request to the provider.
      request = Request.new @common_options
      request.assignee = users :provider
      request.save

      assert_equal users(:administrator), @system.next_assignee
    end
  end
end
