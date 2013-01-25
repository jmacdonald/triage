class Responsibility < ActiveRecord::Base
  belongs_to :user
  belongs_to :system

  validates :user, :system, :presence => true
end
