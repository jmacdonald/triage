require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  subject { requests :valid }

  should belong_to :user
  should validate_presence_of :title
  should validate_presence_of :description
end
