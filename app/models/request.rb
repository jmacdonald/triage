class Request < ActiveRecord::Base
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  belongs_to :assignee, :class_name => 'User', :foreign_key => 'assignee_id'
  belongs_to :status
  has_many :comments
  has_many :attachments
  attr_accessible :description, :title

  validates :title, :description, :requester, :presence => true

  def to_s
    self.title
  end
end
