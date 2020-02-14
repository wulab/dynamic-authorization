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
    return object if object.is_a?(Hash)
    return { class: object } if object.is_a?(Class)

    {
      class: object.class,
      id: object.object_id
    }
  end

  def rule_comply?(rule, object)
    if rule.length == 0
      true
    elsif rule.length == 1
      rule.any? { |k, v| object == v || object.send(k) == v }
    else
      first = rule.slice(rule.keys[0])
      rest = rule.slice(*rule.keys[1..-1])
      rule_comply?(first, object) && rule_comply?(rest, object)
    end
  end
end
