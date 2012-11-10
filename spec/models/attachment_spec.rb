require 'spec_helper'

describe Attachment do
  subject { FactoryGirl.create :attachment }

  it { should belong_to :request }
  it { should belong_to :user }
  it { should allow_mass_assignment_of :title }
  it { should allow_mass_assignment_of :file }
  it { should validate_presence_of :title }
  it { should validate_presence_of :request }
  it { should validate_presence_of :user }
  it { should have_attached_file :file }
  it { should validate_attachment_presence :file }
  it { should validate_attachment_size(:file).less_than 5.megabytes }

  describe 'file_name method' do
    it 'should exist' do
      assert subject.respond_to? 'file_name'
    end

    it 'should return the same value as file_file_name' do
      assert_equal subject.file_file_name, subject.file_name
    end
  end
end
