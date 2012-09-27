class Request < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  attr_accessible :description, :title

  validates :title, :description, :user, :presence => true
end
