class Follow < ActiveRecord::Base
  belongs_to :follower, class_name: "User",
    foreign_key: :follower_id, counter_cache: :followees_count
  belongs_to :followee, class_name: "User",
    foreign_key: :followee_id, counter_cache: :followers_count

  before_create :check_if_already_followed

  private
  def check_if_already_followed
    false if Follow.exists?(follower_id: follower_id, followee_id: followee_id)
  end
end
