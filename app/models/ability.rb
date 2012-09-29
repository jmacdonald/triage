class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == 'administrator'
      can :manage, :all
    elsif user.role == 'provider'
      can :read, Request

      # Manage (but not delete) requests assigned to them.
      can :manage, Request, :assignee_id => user.id
      cannot :destroy, Request

      can :create, Comment
    elsif user.role == 'requester'
      # Read requests created by them.
      can :read, Request, :requester_id => user.id

      can :create, Request
      can :create, Comment
    end
  end
end
