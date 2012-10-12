class Attachment < ActiveRecord::Base
  belongs_to :request
  belongs_to :user

  validates :request, :user, :presence => true
  has_attached_file :file
  attr_accessible :file
end
