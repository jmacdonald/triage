require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  subject { statuses :valid }

  should validate_presence_of :title
end
