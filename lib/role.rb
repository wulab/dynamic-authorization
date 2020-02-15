class Role
  attr_reader :name, :permissions

  def initialize(name)
    @name = name
    @permissions = []
  end

  def assign(permission)
    @permissions << permission
  end

  def permit(action, object)
    @permissions << Permission.new(action, object)
  end

  def permit?(action, object)
    @permissions.any? { |permission| permission.permit?(action, object) }
  end
end
