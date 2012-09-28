require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  subject { statuses :valid }

  should have_many :requests
  should validate_presence_of :title
  should ensure_inclusion_of(:default).in_array ['true', 'false', 'asdf']
  should ensure_inclusion_of(:closed).in_array ['true', 'false', 'asdf']

  context 'a new default status' do
    setup do
      # Create a new default status.
      @status = Status.new
      @status.title = 'Closed'
      @status.default = true
      @status.save
    end

    should 'should keep its default flag' do
      assert @status.default
    end

    should 'cause the previous default status to be unset' do
      assert_equal 1, Status.where(:default => true).count
    end
  end
end
