class User
  attr_reader :name, :permittables

  def initialize(name)
    @name = name
    @permittables = []
  end

  def acquire(role_or_permission)
    @permittables << role_or_permission
  end

  def can?(action, object)
    @permittables.any? { |ability| ability.allow?(action, object) }
  end
end
