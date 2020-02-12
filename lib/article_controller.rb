require_relative './article'

class ArticleController
  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def create
    @article = Article.new("Lorem ipsum")
    raise unless user.can?(:create_article, account)
    :ok
  rescue
    :unauthorized
  end
end
