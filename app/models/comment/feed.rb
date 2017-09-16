class Comment < ActiveRecord::Base
  class Feed
    def initialize(params = {})
      @user     = params[:user]
      @page     = params[:page]
      @per_page = params.fetch(:per_page, 10)
    end

    def comments
      by_time
    end

    private

    attr_reader :user, :page, :per_page

    def by_time
      base_scope.recent.paginate(page: page, per_page: per_page)
    end

    def base_scope
      Comment.where("user_id IN (:followee_ids)",
                    followee_ids: user_followee_ids)
    end

    def user_followee_ids
      user.followees.pluck(:id)
    end
  end
end
