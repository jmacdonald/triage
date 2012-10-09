require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  subject { attachments :valid }

  should belong_to :request
  should belong_to :user
  should validate_presence_of :request
end
