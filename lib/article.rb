class Article
  attr_reader :title
  attr_accessor :published

  def initialize(title)
    @title = title
  end

  def id
    object_id
  end

  def published?
    !!published
  end
end
