class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => 'assigned_to_id'
  has_many :comments
  attr_accessible :description, :title

  validates :title, :description, :user, :presence => true
end
