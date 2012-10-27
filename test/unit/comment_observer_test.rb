require 'test_helper'

class CommentObserverTest < ActiveSupport::TestCase
  context 'creating a comment' do
    should 'send the right email' do
      request = requests :valid
      @comment = request.comments.new
      @comment.content = 'This is a comment.'
      @comment.user = users :requester
      @comment.save

      # Ensure that the proper email is queued.
      assert_equal "#{@comment.user.name} commented on #{@comment.request}", ActionMailer::Base.deliveries[0].subject
    end

    context 'on an unassigned request' do
      setup do
        @request = requests :unassigned
        @comment = @request.comments.new
        @comment.content = 'This is a comment.'
      end

      context 'when the author is the requester' do
        setup do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @request.requester = users :requester
          @comment.user = users :requester
          @request.save
          @comment.save
        end

        should 'not send an email' do
          # Ensure that no email is queued for delivery.
          assert_equal 0, ActionMailer::Base.deliveries.size
        end
      end

      context 'when the author is not the requester' do
        setup do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @request.requester = users :requester
          @comment.user = users :provider
          @request.save
          @comment.save
        end

        should 'send an email' do
          # Ensure that an email is queued for delivery.
          assert_equal 1, ActionMailer::Base.deliveries.size
        end

        should 'send the email to the requester' do
          assert ActionMailer::Base.deliveries[0].to.include? @request.requester.email
        end
      end
    end

    context 'on an assigned request' do
      setup do
        @request = requests :valid
        @comment = @request.comments.new
        @comment.content = 'This is a comment.'
      end

      context 'when the author is the requester' do
        setup do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @request.requester = users :requester
          @comment.user = users :requester
          @request.save
          @comment.save
        end

        should 'send an email' do
          # Ensure that an email is queued for delivery.
          assert_equal 1, ActionMailer::Base.deliveries.size
        end

        should 'send the email to the assignee' do
          assert ActionMailer::Base.deliveries[0].to.include? @request.assignee.email
        end
      end

      context 'when the author is the assignee' do
        setup do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @request.requester = users :requester
          @comment.user = @request.assignee
          @request.save
          @comment.save
        end

        should 'send an email' do
          # Ensure that an email is queued for delivery.
          assert_equal 1, ActionMailer::Base.deliveries.size
        end

        should 'send the email to the requester' do
          assert ActionMailer::Base.deliveries[0].to.include? @request.requester.email
        end
      end

      context 'when the author is neither the assignee nor the requester' do
        setup do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @request.requester = users :requester
          @comment.user = users :administrator
          @request.save
          @comment.save
        end

        should 'send an email' do
          # Ensure that an email is queued for delivery.
          assert_equal 1, ActionMailer::Base.deliveries.size
        end

        should 'send the email to the requester' do
          assert ActionMailer::Base.deliveries[0].to.include? @request.requester.email
        end

        should 'send the email to the assignee' do
          assert ActionMailer::Base.deliveries[0].to.include? @request.assignee.email
        end
      end
    end

    context 'with user mentions' do
      setup do
        # Clear previous deliveries before each test.
        ActionMailer::Base.deliveries = []

        request = requests :valid
        @user1  = users :administrator
        @user2  = users :provider
        @comment = request.comments.new
        @comment.content = "@#{@user1.username} @#{@user2.username} have either of you guys seen this before?"
        @comment.user = users :requester
        @comment.save
      end

      should 'send the email to the first referenced user' do
        assert ActionMailer::Base.deliveries[0].to.include? @user1.email
      end

      should 'send the email to the second referenced user' do
        assert ActionMailer::Base.deliveries[0].to.include? @user2.email
      end
    end
  end
end
