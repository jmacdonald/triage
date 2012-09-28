class Request < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :assignee, :class_name => 'User', :foreign_key => 'assignee_id'
  belongs_to :status
  has_many :comments
  attr_accessible :description, :title

  validates :title, :description, :author, :presence => true
end
