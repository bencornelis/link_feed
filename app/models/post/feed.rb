class Post < ActiveRecord::Base
  class Feed < Struct.new(:filter, :user)

    def posts
      @posts ||= filter.for(base.feed.scope).select_posts
    end

    protected

    def scope
      @scope
    end

    def base
      @scope = Post.includes(:tags, :user).joins(:shares)
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
