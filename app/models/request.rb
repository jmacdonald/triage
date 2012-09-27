class Request < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title

  validates :title, :description, :presence => true
end
