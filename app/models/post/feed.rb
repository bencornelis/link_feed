class Post < ActiveRecord::Base
  class Feed
    def initialize(params = {})
      @tag      = params[:tag]
      @page     = params[:page]
      @per_page = params.fetch(:per_page, 10)
      @sort     = params[:sort]
      @user     = params[:user]
    end

    def posts
      sort == "time" ? by_time : by_score
    end

    private

    attr_reader :tag, :page, :per_page, :sort, :user

    def by_score
      score_scope.filter_tag_and_page(tag, page, per_page)
    end

    def by_time
      base_scope.by_time.filter_tag_and_page(tag, page, per_page)
    end

    def score_scope
      base_scope.group("posts.id").order("#{score_sql} desc")
    end

    def score_sql
      "(COUNT(shares.id) - 1)/POWER(EXTRACT(EPOCH FROM (NOW() - posts.created_at)) + 2, 1.8)"
    end

    def base_scope
      Post.joins(:shares)
          .where("shares.user_id IN (:followee_ids)", followee_ids: user_followee_ids)
    end

    def user_followee_ids
      user.followees.pluck(:id)
    end
  end
end
