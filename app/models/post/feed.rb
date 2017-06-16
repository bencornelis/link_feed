class Post < ActiveRecord::Base
  class Feed < Filter
    def base
      Post.preload(:tags, {:user => :roles})
          .joins(:shares)
          .select("posts.*", "COUNT(shares.id) AS followee_shares_count")
          .where("shares.user_id IN (:followee_ids)", followee_ids: user_followee_ids)
          .group("posts.id")
          .order("followee_shares_count desc")
    end

    def user_followee_ids
      user.followees.pluck(:id)
    end
  end
end
