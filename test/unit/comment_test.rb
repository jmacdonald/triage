require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  subject { comments :valid }

  should belong_to :user
  should belong_to :request
  should validate_presence_of :content
end
