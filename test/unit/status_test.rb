require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  subject { statuses :valid }

  should have_many :requests
  should validate_presence_of :title
end
