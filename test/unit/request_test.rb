require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  subject { requests :valid }

  should belong_to :author
  should belong_to :assignee
  should belong_to :status
  should have_many :comments
  should validate_presence_of :title
  should validate_presence_of :description
  should validate_presence_of :author
end
