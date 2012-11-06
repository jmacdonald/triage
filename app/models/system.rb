class System < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
  has_many :requests

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    self.name
  end
end
