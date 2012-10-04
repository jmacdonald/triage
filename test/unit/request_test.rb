require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  subject { requests :valid }

  should belong_to :requester
  should belong_to :assignee
  should belong_to :status
  should have_many :comments
  should have_many :attachments
  should validate_presence_of :title
  should validate_presence_of :description
  should validate_presence_of :requester

  test 'that requests can display themselves as strings' do
    assert_equal 'System is not working', requests(:valid).to_s
  end
end
