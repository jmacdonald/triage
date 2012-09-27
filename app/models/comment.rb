class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :request
  attr_accessible :content

  validates :content, :presence => true
end
