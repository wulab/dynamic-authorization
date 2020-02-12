class Role
  attr_reader :name, :permissions

  def initialize(name)
    @name = name
    @permissions = []
  end

  def permit(action, object)
    @permissions << Permission.new(action, object)
  end

  def allow?(action, object)
    @permissions.any? { |permission| permission.allow?(action, object) }
  end
end
