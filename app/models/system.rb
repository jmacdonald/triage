class System < ActiveRecord::Base
  attr_accessible :name
  has_many :requests

  validates :name, :presence => true

  def to_s
    self.name
  end
end
