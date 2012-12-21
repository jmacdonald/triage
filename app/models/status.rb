class Status < ActiveRecord::Base
  attr_accessible :closed, :default, :title
  has_many :requests

  validates :title, :presence => true

  before_save :clear_defaults, :if => :default?
  before_destroy :ensure_unused

  def self.default
    self.where(:default => true).first
  end

  def clear_defaults
    Status.update_all :default => false
  end

  def to_s
    self.title
  end

  def ensure_unused
    self.requests.empty?
  end
end
