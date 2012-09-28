require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  subject { statuses :valid }

  should have_many :requests
  should validate_presence_of :title
  should ensure_inclusion_of(:default).in_array ['true', 'false', 'asdf']
  should ensure_inclusion_of(:closed).in_array ['true', 'false', 'asdf']
end
