class System < ActiveRecord::Base
  attr_accessible :name
  has_many :requests
  has_many :responsibilities
  has_many :users, :through => :responsibilities

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    self.name
  end
end
