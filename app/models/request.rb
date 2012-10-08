class Request < ActiveRecord::Base
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  belongs_to :assignee, :class_name => 'User', :foreign_key => 'assignee_id'
  belongs_to :status
  belongs_to :system
  has_many :comments
  has_many :attachments
  attr_accessible :description, :title, :system_id, :assignee_id, :status_id

  validates :status, :title, :description, :requester, :system, :presence => true

  before_validation :set_default_status, :if => "status.nil?"

  def to_s
    self.title
  end

  def set_default_status
    self.status = Status.default

    if self.status.nil?
      logger.error 'Requests cannot be created without a default status; please create one.'
    end
  end
end
