class Permission
  attr_reader :action, :object, :context

  # Permission.new(:update, Article)
  # Permission.new(:update, Article, account)
  # Permission.new(:update, article)
  def initialize(action, object, context=nil)
    @action = action
    @object = object
    @context = context
  end

  def allow?(target_action, target_object)
    action == target_action &&
      (object == target_object || object == target_object.class) &&
      object_in_context?(target_object)
  end

  private

  def object_in_context?(target_object)
    return true if context.nil?

    case target_object
    when Article
      context.articles.include?(target_object)
    else
      raise NotImplementedError
    end
  end
end
