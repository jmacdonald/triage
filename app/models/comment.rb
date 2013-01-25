class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :request

  validates :content, :presence => true
end
