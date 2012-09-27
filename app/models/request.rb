class Request < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title
end
