require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  subject { systems :valid }

  should validate_presence_of :name
end
