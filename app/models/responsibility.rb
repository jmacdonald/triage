class Responsibility < ActiveRecord::Base
  attr_accessible :system_id, :user_id
  belongs_to :user
  belongs_to :system

  validates :user, :system, :presence => true
end
