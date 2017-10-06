class Comment < ActiveRecord::Base
  class Global
    def initialize(params = {})
      @page     = params[:page]
      @per_page = params.fetch(:per_page, 10)
    end

    def comments
      by_score
    end

    private

    attr_reader :page, :per_page

    def by_score
      base_scope.by_score.paginate(page: page, per_page: per_page)
    end

    def base_scope
      Comment.all
    end
  end
end
