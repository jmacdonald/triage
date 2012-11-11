require 'spec_helper'

describe Notifier do
  before(:all) do
    Request.observers.disable :all
    Comment.observers.disable :all
  end

  describe 'assignment email' do
    before(:each) do
      @assignee = FactoryGirl.create :user, role: 'administrator'
      @request = FactoryGirl.create :request, assignee: @assignee
      @email = Notifier.assignment(@request).deliver
    end

    it 'should be queued for delivery' do
      ActionMailer::Base.deliveries.empty?.should be_false
    end

    it 'should be sent to the assignee' do
      @email.to.should eq([@request.assignee.email])
    end

    it 'should have the right subject' do
      @email.subject.should eq("You've been assigned a request")
    end

    it 'should contain the request title' do
      @email.encoded.should match(/#{@request.title}/)
    end

    it 'should contain the request description' do
      @email.encoded.should match(/#{@request.description}/)
    end
  end

  describe 'comment email' do
    before(:each) do
      @comment = FactoryGirl.create :comment
      @users = [FactoryGirl.create(:user)]
      @email = Notifier.comment(@comment, @users).deliver
    end
    
    it 'should be queued for delivery' do
      ActionMailer::Base.deliveries.size.should eq(1)
    end

    it 'should be sent to the specified users' do
      email_addresses = @users.collect {|user| user.email}
      @email.to.should eq(email_addresses)
    end

    it 'should have the right subject' do
      @email.subject.should eq("#{@comment.user.name} commented on #{@comment.request}")
    end

    it 'should contain the comment content' do
      @email.encoded.should match(/#{@comment.content}/)
    end
  end

  describe 'mention email' do
    before(:each) do
      @comment = FactoryGirl.create :comment
      @users = [FactoryGirl.create(:user)]
      @email = Notifier.mention(@comment, @users).deliver
    end
    
    it 'should be queued for delivery' do
      ActionMailer::Base.deliveries.size.should eq(1)
    end

    it 'should be sent to the specified users' do
      email_addresses = @users.collect {|user| user.email}
      @email.to.should eq(email_addresses)
    end

    it 'should have the right subject' do
      @email.subject.should eq("#{@comment.user.name} mentioned you in a comment")
    end

    it 'should contain the comment content' do
      @email.encoded.should match(/#{@comment.content}/)
    end
  end
end
