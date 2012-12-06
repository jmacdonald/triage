class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  ROLE_OPTIONS = %w(administrator provider requester)

  devise :ldap_authenticatable, :database_authenticatable, :rememberable, :trackable, :validatable

  has_many :requests, :foreign_key => :requester_id
  has_many :assignments, :class_name => 'Request', :foreign_key => :assignee_id
  has_many :comments
  has_many :attachments
  has_many :responsibilities
  has_many :systems, :through => :responsibilities

  validates :username, :role, :name, :presence => true
  validates :username, :uniqueness => true, :format => /^\w+$/
  validates :role, :inclusion => { :in => ROLE_OPTIONS }

  scope :available, where(available: true)

  def to_s
    self.name
  end
end
