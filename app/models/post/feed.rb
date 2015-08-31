class Post < ActiveRecord::Base
  class Feed < Post::Filter
    attr_reader :user

    def initialize(attributes = {})
      super(attributes)
      @user = attributes[:user]
    end

    def posts
      @posts ||= base.feed.filter.scope
    end

    protected

    def base
      @scope = super.scope.joins(:shares)
      self
    end

    def feed
      @scope =
        @scope.select("posts.*", "COUNT(shares.id) AS followee_shares_count")
              .where("shares.user_id IN (:followee_ids) OR posts.user_id IN (:followee_ids)",
                followee_ids: user_followee_ids)
              .group("posts.id")
              .order("followee_shares_count desc")
      self
    end

    private

    def user_followee_ids
      user.followees.pluck(:id).to_a
    end
  end
end
