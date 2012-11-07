require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  subject { systems :valid }

  should have_many :requests
  should have_many :responsibilities
  should have_many(:users).through(:responsibilities)
  should validate_presence_of :name
  should validate_uniqueness_of :name

  test 'that a system can display itself' do
    assert_equal 'Triage', systems(:valid).to_s
  end
end
