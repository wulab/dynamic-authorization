require_relative './article'

class ArticleController
  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def create
    @article = Article.new("Lorem ipsum")
    account.publish(@article)
    raise unless user.can?(:create, @article)
    :ok
  rescue
    :unauthorized
  end
end
