require 'test_helper'

class RequestObserverTest < ActiveSupport::TestCase
  context 're-assigning a request' do
    setup do
      request = requests :valid
      new_assignee = users :provider

      # Re-assign the request.
      request.assignee = new_assignee
      request.save
    end

    should 'send an email' do
      # Ensure that an email is queued for delivery.
      assert_equal 1, ActionMailer::Base.deliveries.size
    end

    should 'send the right email' do
      # Ensure that the proper email is queued.
      assert_equal "You've been assigned a request", ActionMailer::Base.deliveries[0].subject
    end
  end
end
