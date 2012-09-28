class Attachment < ActiveRecord::Base
  belongs_to :request

  validates :request, :presence => true
end
