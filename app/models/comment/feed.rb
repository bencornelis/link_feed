class Comment < ActiveRecord::Base
  class Feed
    def initialize(params = {})
      @page     = params[:page]
      @user     = params[:user]
      @per_page = params.fetch(:per_page, 10)
    end

    def recent
      base_scope.recent.paginate(page: page, per_page: per_page)
    end

    private

    attr_reader :tag, :page, :user, :per_page

    def base_scope
      Comment.preload(:post, {:user => :roles})
             .where("user_id IN (:followee_ids)", followee_ids: user_followee_ids)
    end

    def user_followee_ids
      user.followees.pluck(:id)
    end
  end
end
