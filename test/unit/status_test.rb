require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  subject { statuses :valid }

  should have_many :requests
  should validate_presence_of :title
  should ensure_inclusion_of(:default).in_array [true, false]
  should ensure_inclusion_of(:closed).in_array [true, false]

  test 'that statuses can display themselves as strings' do
    assert_equal 'New', statuses(:valid).to_s
  end

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

  test 'that a "default" method exists on the class' do
    assert Status.respond_to?(:default), 'default method does not exist'
  end

  test 'that the "default" method returns a single status with its default flag set' do
    assert_equal statuses(:valid), Status.default
  end

  test 'that null "default" values are defaulted to false' do
    assert_equal 2, Status.where(:default => false).count
  end

  test 'that null "closed" values are defaulted to false' do
    assert_equal 2, Status.where(:closed => false).count
  end
end
