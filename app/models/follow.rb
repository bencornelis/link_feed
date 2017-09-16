class Follow < ActiveRecord::Base
  belongs_to :follower, class_name: "User",
    foreign_key: :follower_id, counter_cache: :followees_count
  belongs_to :followee, class_name: "User",
    foreign_key: :followee_id, counter_cache: :followers_count

  validates :follower_id, uniqueness: { scope: :followee_id }
end
