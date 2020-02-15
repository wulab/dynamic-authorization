class User
  attr_reader :name, :abilities

  def initialize(name)
    @name = name
    @abilities = []
  end

  def id
    object_id
  end

  def assign(role_or_permission)
    @abilities << role_or_permission
  end

  def permit(action, object)
    @abilities << Permission.new(action, object)
  end

  def permit?(action, object)
    @abilities.any? { |ability| ability.permit?(action, object) }
  end
  alias :can? :permit?
end
