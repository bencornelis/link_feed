class Comment < ActiveRecord::Base
  class Global
    def initialize(params = {})
      @page     = params[:page]
      @per_page = params.fetch(:per_page, 10)
    end

    def comments
      by_time
    end

    private

    attr_reader :page, :per_page

    def by_time
      base_scope.recent.paginate(page: page, per_page: per_page)
    end

    def base_scope
      Comment.all
    end
  end
end
