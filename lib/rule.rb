class Rule
  attr_reader :repr

  # Rule.new(Article)
  # Rule.new(article)
  # Rule.new({ class: "Article", published: true })
  def initialize(object)
    @repr = convert_to_repr(object)
  end

  def comply?(object)
    rule_comply?(repr, object)
  end

  private

  def convert_to_repr(object)
    return object if rule?(object)
    return { class: object } if type?(object)

    {
      class: object.class,
      id: object.object_id
    }
  end

  def rule_comply?(rule, object)
    if object.nil?
      rule.length == 0
    elsif rule.length == 0
      true
    elsif rule.length == 1
      key, value = rule.flatten

      if rule?(value)
        object.respond_to?(key) && rule_comply?(value, object.send(key))
      elsif type?(value)
        object == value || object.class == value
      else
        object.respond_to?(key) && object.send(key) == value
      end
    else
      first = rule.slice(rule.keys[0])
      rest = rule.slice(*rule.keys[1..-1])
      rule_comply?(first, object) && rule_comply?(rest, object)
    end
  end

  def rule?(rule)
    rule.is_a?(Hash)
  end

  def type?(object)
    object.is_a?(Class)
  end
end
