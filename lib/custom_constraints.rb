# Based on http://collectiveidea.com/blog/archives/2011/05/31/user-centric-routing-in-rails-3/
class RoleConstraint < Struct.new(:value)
  def matches?(request)
    request.env["warden"].user.role == value
  end
end