require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  subject { systems :valid }

  should have_many :requests
  should validate_presence_of :name
end
