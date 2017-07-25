class Post < ActiveRecord::Base
  class Global
    def initialize(params = {})
      @tag      = params[:tag]
      @page     = params[:page]
      @per_page = params.fetch(:per_page, 10)
      @sort     = params[:sort]
    end

    def posts
      sort == "time" ? by_time : by_score
    end

    private

    attr_reader :tag, :page, :per_page, :sort

    def by_score
      score_scope.filter_tag_and_page(tag, page, per_page)
    end

    def by_time
      base_scope.by_time.filter_tag_and_page(tag, page, per_page)
    end

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
