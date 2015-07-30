class TagsController < ApplicationController
  def index
    @recent_tags = Tag.recent(5)
    @popular_tags = Tag.popular(5)
  end

end
