require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  subject { statuses :valid }

  should have_many :requests
  should validate_presence_of :title
  should ensure_inclusion_of(:default).in_array [true, false]
  should ensure_inclusion_of(:closed).in_array [true, false]

  context 'a new default status' do
    setup do
      # Create a new default status.
      @status = Status.new
      @status.title = 'Closed'
      @status.default = true
      @status.save
    end

    should 'keep its default flag' do
      assert @status.default
    end

    should 'cause the previous default status to be unset' do
      assert_false statuses(:valid).default?
    end

    should 'result in a single status being the default' do
      assert_equal 1, Status.where(:default => true).count
    end
  end

  context 'a new non-default status' do
    setup do
      # Create a new default status.
      @status = Status.new
      @status.title = 'Closed'
      @status.default = false
      @status.save
    end

    should 'not change the pre-existing default status' do
      assert statuses(:valid).default?
    end

    should 'result in a single status being the default' do
      assert_equal 1, Status.where(:default => true).count
    end
  end
end
