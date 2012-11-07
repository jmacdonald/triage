require 'test_helper'

class ResponsibilityTest < ActiveSupport::TestCase
  subject { responsibilities :valid }

  should belong_to :user
  should belong_to :system
  should validate_presence_of :user
  should validate_presence_of :system
end
