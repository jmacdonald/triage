class RoleConstraint

  def initialize(role)
    @role = role
  end

  def matches?(request)
    request.env["warden"].user.role == @role
  end

end