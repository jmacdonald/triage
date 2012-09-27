require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  subject { requests :valid }

  should belong_to :user
end
