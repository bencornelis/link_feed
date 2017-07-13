class Comment < ActiveRecord::Base
  class Global
    def initialize(params = {})
      @page     = params[:page]
      @per_page = params.fetch(:per_page, 10)
    end

    def recent
      base_scope.recent.paginate(page: page, per_page: per_page)
    end

    private

    attr_reader :page, :per_page

    def base_scope
      Comment.all
    end
  end
end
