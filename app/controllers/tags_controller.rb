class TagsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @recent_tags = Tag.recent(5)
        @popular_tags = Tag.popular(5)
      end
      
      format.js do
        tags = Tag.search(params[:term])
        render json: tags
      end
    end
  end
end
