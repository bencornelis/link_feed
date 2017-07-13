class Post < ActiveRecord::Base
  class Global
    def initialize(params = {})
      @tag      = params[:tag]
      @page     = params[:page]
      @per_page = params.fetch(:per_page, 10)
    end

    def by_score
      score_scope.filter_tag_and_page(tag, page, per_page)
    end

    def recent
      base_scope.by_time.filter_tag_and_page(tag, page, per_page)
    end

    private

    attr_reader :tag, :page, :per_page

    def score_scope
      base_scope.order("#{score_sql} desc")
    end

    def score_sql
      # Hacker News Ranking
      "(posts.shares_count - 1)/POWER(EXTRACT(EPOCH FROM (NOW() - posts.created_at)) + 2, 1.8)"
    end

    def base_scope
      Post.all
    end
  end
end
