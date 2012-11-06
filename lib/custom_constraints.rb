class RoleConstraint

  def initialize(role)
    @role = role
  end

  def matches?(request)
    if request.env['warden'].user
      request.env['warden'].user.role == @role
    else
      false
    end
  end

end