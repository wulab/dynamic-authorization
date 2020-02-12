class Account
  attr_reader :name, :roles, :articles

  def initialize(name)
    @name = name
    @roles = []
    @articles = []
  end

  def publish(article)
    @articles << article
  end
end
