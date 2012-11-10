require 'spec_helper'

describe RequestObserver do
  before(:each) do
    # Clear previous deliveries before each test.
    ActionMailer::Base.deliveries = []

    @provider = FactoryGirl.create :user, role: 'provider'
  end

  context 'assigning a request as part of its creation' do
    before(:each) do
      request = FactoryGirl.create :request, assignee: @provider
    end

    it 'should send an email' do
      # Ensure that an email is queued for delivery.
      ActionMailer::Base.deliveries.size.should eq(1)
    end

    it 'should send the right email' do
      # Ensure that the proper email is queued.
      ActionMailer::Base.deliveries[0].subject.should eq("You've been assigned a request")
    end
    
    it 'should send the email to the assignee' do
      ActionMailer::Base.deliveries[0].to.include?(@provider.email).should be_true
    end
  end

  context 're-assigning an existing request' do
    before(:each) do
      request = FactoryGirl.create :request

      # Re-assign the request.
      request.assignee = @provider
      request.save
    end

    it 'should send an email' do
      # Ensure that an email is queued for delivery.
      assert_equal 1, ActionMailer::Base.deliveries.size
    end

    it 'should send the right email' do
      # Ensure that the proper email is queued.
      assert_equal "You've been assigned a request", ActionMailer::Base.deliveries[0].subject
    end
    
    it 'should send the email to the assignee' do
      ActionMailer::Base.deliveries[0].to.include?(@provider.email).should be_true
    end
  end
end
