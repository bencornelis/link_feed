class Post < ActiveRecord::Base
  class Global
    BADGING_FACTOR = 20

    def initialize(params = {})
      @sort = params[:sort]
      @filter_options = params.slice(:tag, :page, :per_page)
    end

    def posts
      sort == "time" ? by_time : by_score
    end

    private

    attr_reader :sort, :filter_options

    def by_score
      score_scope.filter(filter_options)
    end

    def by_time
      base_scope.by_time.filter(filter_options)
    end

    def score_scope
      base_scope.order("#{score_sql} desc")
    end

    def score_sql
      # Hacker News Ranking
      "(posts.shares_count + #{BADGING_FACTOR} * posts.badgings_count - 1)" +
      "/POWER(EXTRACT(EPOCH FROM (NOW() - posts.created_at)) + 2, 1.8)"
    end

    def base_scope
      Post.all
    end
  end
end
