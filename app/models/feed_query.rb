class FeedQuery
  attr_reader :user, :options
  def initialize(user, options)
    @user    = user
    @options = options
  end

  def filter_feed
    user_followee_ids = user.followees.pluck(:id).to_a
    Post.includes(:tags, :user)
        .joins(:shares)
        .select("posts.*",
                "COUNT(shares.id) AS followee_shares_count")
        .where("shares.user_id IN (:followee_ids) OR posts.user_id IN (:followee_ids)",
                followee_ids: user_followee_ids)
        .group("posts.id")
        .order("followee_shares_count desc")
        .filter(options)
  end
end
