require_relative './article'

class ArticleController
  attr_reader :role

  def initialize(role)
    @role = role
  end

  def create
    @article = Article.new("Lorem ipsum")
    raise unless @role.allow?(:create, @article)
    :ok
  rescue
    :unauthorized
  end
end
