class Status < ActiveRecord::Base
  attr_accessible :closed, :default, :title
  has_many :requests

  validates :title, :presence => true
end
