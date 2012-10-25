require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  context 'assignment email' do
    setup do
      @request = requests :valid
      @email = Notifier.assignment_email(@request).deliver
    end

    should 'be queued for delivery' do
      assert !ActionMailer::Base.deliveries.empty?
    end

    should 'be sent to the assignee' do
      assert_equal [@request.assignee.email], @email.to
    end

    should 'have the right subject' do
      assert_equal "You've been assigned a request", @email.subject
    end
  end
end
