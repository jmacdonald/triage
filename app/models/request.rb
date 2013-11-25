class Request < ActiveRecord::Base
  SEVERITY_OPTIONS = %w(minor moderate major critical)

  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  belongs_to :assignee, -> { where "role = 'administrator' or role ='provider'" }, :class_name => 'User', :foreign_key => 'assignee_id'
  belongs_to :status
  belongs_to :system
  has_many :comments
  has_many :attachments

  validates :status, :title, :description, :requester, :system, :severity, :presence => true
  validates :severity, :inclusion => { :in => SEVERITY_OPTIONS }
  before_validation :set_default_status, :if => "status.nil?"
  before_create :assign, :if => "assignee.nil?"

  scope :closed, -> { joins(:status).where :statuses => {:closed => true} }
  scope :unclosed, -> { joins(:status).where :statuses => {:closed => false} }
  scope :unassigned, -> { where(:assignee_id => nil) }

  def to_s
    "Request ##{self.id}: #{self.title}"
  end

  def set_default_status
    self.status = Status.default

    if self.status.nil?
      logger.error 'Requests cannot be created without a default status; please create one.'
    end
  end

  def assign
    self.assignee = self.system.next_assignee
  end
end
