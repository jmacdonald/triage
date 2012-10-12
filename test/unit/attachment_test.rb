require 'test_helper'
require 'paperclip/matchers'

class AttachmentTest < ActiveSupport::TestCase
  extend Paperclip::Shoulda::Matchers
  subject { attachments :valid }

  should belong_to :request
  should belong_to :user
  should allow_mass_assignment_of :title
  should allow_mass_assignment_of :file
  should validate_presence_of :request
  should validate_presence_of :user
  should have_attached_file :file
  should validate_attachment_presence :file
  should validate_attachment_size(:file).less_than 5.megabytes
end
