require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject { users :valid }

  should have_many :requests
  should have_many :assignments
  should have_many :comments
  should have_many :attachments
  should validate_presence_of :email
  should validate_presence_of :username
  should validate_presence_of :password
  should validate_presence_of :role
  should validate_presence_of :name
  should allow_mass_assignment_of :email
  should allow_mass_assignment_of :username
  should allow_mass_assignment_of :password
  should allow_mass_assignment_of :password_confirmation
  should allow_mass_assignment_of :remember_me
  should allow_mass_assignment_of :name
  should allow_mass_assignment_of :role
  should validate_uniqueness_of :username
  should ensure_inclusion_of(:role).in_array %w(administrator provider requester)

  test 'that users can display themselves as strings' do
    assert_equal 'Valid User', users(:valid).to_s
  end
end
