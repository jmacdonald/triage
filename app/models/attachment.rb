class Attachment < ActiveRecord::Base
  belongs_to :request
  belongs_to :user

  validates :request, :presence => true
end
