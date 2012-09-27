require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject { users :valid }

  should have_many :requests
end
