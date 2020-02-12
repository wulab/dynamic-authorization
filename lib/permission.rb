class Permission
  attr_reader :action, :object

  def initialize(action, object)
    @action = action
    @object = object
  end

  def allow?(target_action, target_object)
    action == target_action &&
      (object == target_object || object == target_object.class)
  end
end
