class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :open, :closed, :to => :read
    user ||= User.new # guest user (not logged in)
    if user.role == 'administrator'
      can :manage, :all
    elsif user.role == 'provider'
      can :read, Request

      # Manage (but not delete) requests assigned to them.
      can :manage, Request, :assignee_id => user.id
      cannot :destroy, Request

      can :create, Request
      can :create, Comment

      can :create, Attachment
      can :destroy, Attachment, :user => { :id => user.id }

      can [:read, :update], User, :id => user.id
    elsif user.role == 'requester'
      # Read requests created by them.
      can :read, Request, :requester_id => user.id

      can :create, Request
      can :create, Comment, :request => { :requester_id => user.id }

      can :create, Attachment, :request => { :requester_id => user.id }
      can :destroy, Attachment, :user => { :id => user.id }

      can [:read, :update], User, :id => user.id
    end
  end
end
