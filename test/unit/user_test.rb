require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject { users :valid }

  should have_many :requests
  should have_many :assignments
  should have_many :comments
end
