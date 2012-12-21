require 'spec_helper'

describe Status do
  subject { FactoryGirl.build :status }

  it { should have_many :requests }
  it { should validate_presence_of :title }

  it 'should be able to display itself as a string' do
    subject.to_s.should eq(subject.title)
  end

  describe 'a new status' do
    before(:each) do
      @status = FactoryGirl.create :status
    end

    it 'should default its "default" value to false' do
      @status.default.should be_false
    end

    it 'should default its "closed" value to false' do
      @status.closed.should be_false
    end
  end

  describe 'a new default status' do
    before(:each) do
      # Create the initial default status.
      @initial_default_status = FactoryGirl.build :status
      @initial_default_status.default = true
      @initial_default_status.save

      # Create a new default status to override it.
      @status = FactoryGirl.build :status
      @status.default = true
      @status.save
    end

    it 'should cause the previous default status to be unset' do
      # Make sure to reload the object before checking it.
      @initial_default_status.reload.default?.should be_false
    end

    it 'should result in a single status being the default' do
      Status.where(:default => true).count.should eq(1)
    end
  end

  describe 'a new non-default status' do
    before(:each) do
      # Create the initial default status.
      @initial_default_status = FactoryGirl.build :status
      @initial_default_status.default = true
      @initial_default_status.save

      # Create a new non-default status.
      @status = FactoryGirl.create :status
    end

    it 'should not change the pre-existing default status' do
      @initial_default_status.default.should be_true
    end

    it 'should result in a single status being the default' do
      Status.where(:default => true).count.should eq(1)
    end
  end

  describe 'default method' do
    it 'should exist' do
      Status.respond_to?(:default).should be_true
    end

    it 'should return a single status with its default flag set' do
      # Create an initial default status.
      @status = FactoryGirl.build :status
      @status.default = true
      @status.save

      Status.default.should eq(@status)
    end
  end

  context 'deleting a status' do
    before(:each) do
      @status = FactoryGirl.create :status
    end

    it 'should succeed when no requests are associated with it' do
      @status.destroy.should be_true
    end

    it 'should fail when requests are associated with it' do
      request = FactoryGirl.create :request, { status: @status }
      @status.destroy.should be_false
    end
  end
end
