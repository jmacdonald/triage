class System < ActiveRecord::Base
  has_many :requests
  has_many :responsibilities
  has_many :users, :through => :responsibilities

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    self.name
  end

  def next_assignee
    # Return nil if nobody is responsible for this system.
    return nil if self.users.available.empty?

    # Return the first user responsible for this system who has
    # not been given an assignment for it, if one exists.
    users_with_assignments = self.requests.select(:assignee_id).uniq.collect { |r| r.assignee_id }
    users_without_assignments = self.users.available.where{ id << users_with_assignments }
    return users_without_assignments.first unless users_without_assignments.empty?

    # Return the user who has had the longest "break" since being assigned a request.
    oldest_request = nil
    self.users.available.each do |user|
      newest_request = user.assignments.where(:system_id => self.id).order('created_at DESC').first
      if oldest_request == nil or newest_request.created_at < oldest_request.created_at
        oldest_request = newest_request
      end
    end

    oldest_request.assignee
  end
end
