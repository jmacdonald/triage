require 'spec_helper'

describe CommentObserver do
  before(:all) do
    # The notifier spec disables these; ensure they're re-enabled.
    Comment.observers.enable :all
  end

  context 'creating a comment' do
    it 'should send the right email' do
      # Clear previous deliveries before each test.
      ActionMailer::Base.deliveries = []

      @comment = FactoryGirl.create :comment

      # Ensure that the proper email is queued.
      ActionMailer::Base.deliveries[0].subject.should eq("#{@comment.user.name} commented on #{@comment.request}")
    end

    context 'on an unassigned request' do
      before(:each) do
        @comment = FactoryGirl.build :comment
      end

      context 'when the author is the requester' do
        before(:each) do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @comment.user = @comment.request.requester
          @comment.save
        end

        it 'should not send an email' do
          # Ensure that no email is queued for delivery.
          ActionMailer::Base.deliveries.size.should eq(0)
        end
      end

      context 'when the author is not the requester' do
        before(:each) do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @comment.save
        end

        it 'should send an email' do
          # Ensure that an email is queued for delivery.
          ActionMailer::Base.deliveries.size.should eq(1)
        end

        it 'should send the email to the requester' do
          ActionMailer::Base.deliveries[0].to.include?(@comment.request.requester.email).should be_true
        end
      end
    end

    context 'on an assigned request' do
      before(:each) do
        @comment = FactoryGirl.build :comment
        @comment.request.assignee = FactoryGirl.build :user
      end

      context 'when the author is the requester' do
        before(:each) do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @comment.user = @comment.request.requester
          @comment.save
        end

        it 'should send an email' do
          # Ensure that an email is queued for delivery.
          ActionMailer::Base.deliveries.size.should eq(1)
        end

        it 'should send the email to the assignee' do
          ActionMailer::Base.deliveries[0].to.include?(@comment.request.assignee.email).should be_true
        end
      end

      context 'when the author is the assignee' do
        before(:each) do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @comment.request.assignee = FactoryGirl.build :user
          @comment.user = @comment.request.assignee
          @comment.save
        end

        it 'should send an email' do
          # Ensure that an email is queued for delivery.
          ActionMailer::Base.deliveries.size.should eq(1)
        end

        it 'should only send an email to the requester' do
          ActionMailer::Base.deliveries[0].to.should eq([@comment.request.requester.email])
        end
      end

      context 'when the author is neither the assignee nor the requester' do
        before(:each) do
          # Clear previous deliveries before each test.
          ActionMailer::Base.deliveries = []

          @comment.request.assignee = FactoryGirl.build :user
          @comment.save
        end

        it 'should send an email' do
          # Ensure that an email is queued for delivery.
          ActionMailer::Base.deliveries.size.should eq(1)
        end

        it 'should send the email to the requester' do
          ActionMailer::Base.deliveries[0].to.include?(@comment.request.requester.email).should be_true
        end

        it 'should send the email to the assignee' do
          ActionMailer::Base.deliveries[0].to.include?(@comment.request.assignee.email).should be_true
        end
      end
    end

    context 'with user mentions' do
      before(:each) do
        # Clear previous deliveries before each test.
        ActionMailer::Base.deliveries = []

        @user1  = FactoryGirl.create :user
        @user2  = FactoryGirl.create :user
        @comment = FactoryGirl.build :comment
        @comment.content = "@#{@user1.username} @#{@user2.username} have either of you guys seen this before?"
        @comment.save
      end

      it 'should send the email to the first referenced user' do
        ActionMailer::Base.deliveries[0].to.include?(@user1.email).should be_true
      end

      it 'should send the email to the second referenced user' do
        ActionMailer::Base.deliveries[0].to.include?(@user2.email).should be_true
      end
    end
  end
end
