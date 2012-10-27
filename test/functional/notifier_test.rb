require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  context 'assignment email' do
    setup do
      @request = requests :valid
      @email = Notifier.assignment(@request).deliver
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

    should 'contain the request title' do
      assert_match /#{@request.title}/, @email.encoded
    end

    should 'contain the request description' do
      assert_match /#{@request.description}/, @email.encoded
    end
  end

  context 'comment email' do
    setup do
      @comment = comments :valid
      @users = [users(:valid)]
      @email = Notifier.comment(@comment, @users).deliver
    end
    
    should 'be queued for delivery' do
      assert_equal 1, ActionMailer::Base.deliveries.size
    end

    should 'be sent to the specified users' do
      email_addresses = @users.collect {|user| user.email}
      assert_equal email_addresses, @email.to
    end

    should 'have the right subject' do
      assert_equal "#{@comment.user.name} commented on #{@comment.request}", @email.subject
    end

    should 'contain the comment content' do
      assert_match /#{@comment.content}/, @email.encoded
    end
  end
end
