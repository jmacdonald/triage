class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  ROLE_OPTIONS = %w(administrator provider requester)

  has_many :requests, :foreign_key => :requester_id
  has_many :assignments, :class_name => 'Request', :foreign_key => :assignee_id
  has_many :comments
  has_many :attachments
  has_many :responsibilities, :inverse_of => :user
  has_many :systems, :through => :responsibilities

  validates :username, :email, :role, :name, :presence => true
  validates :email, :uniqueness => true
  validates :username, :uniqueness => true, :format => /^\w+$/
  validates :role, :inclusion => { :in => ROLE_OPTIONS }

  scope :available, where(available: true)

  def to_s
    self.name
  end
end
