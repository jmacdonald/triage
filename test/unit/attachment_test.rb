require 'test_helper'
require 'paperclip/matchers'

class AttachmentTest < ActiveSupport::TestCase
  extend Paperclip::Shoulda::Matchers
  subject { attachments :valid }

  should belong_to :request
  should belong_to :user
  should allow_mass_assignment_of :title
  should allow_mass_assignment_of :file
  should validate_presence_of :title
  should validate_presence_of :request
  should validate_presence_of :user
  should have_attached_file :file
  should validate_attachment_presence :file
  should validate_attachment_size(:file).less_than 5.megabytes

  context 'file_name method' do
    setup do
      @attachment = attachments :valid
      @attachment.file = File.new 'test/fixtures/files/attachment.png'
    end

    should 'exist' do
      assert @attachment.respond_to? 'file_name'
    end

    should 'return the same value as file_file_name' do
      assert_equal @attachment.file_file_name, @attachment.file_name
    end
  end
end
