require_relative './rule'

class Permission
  attr_reader :permitted_action, :rule

  # Permission.new(:update, Article)
  # Permission.new(:update, article)
  # Permission.new(:update, { class: "Article", published: true })
  def initialize(permitted_action, object)
    @permitted_action = permitted_action.to_sym
    @rule = Rule.new(object)
  end

  def permit?(action, object)
    permitted_action == action.to_sym && rule.comply?(object)
  end
end
