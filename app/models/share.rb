class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, :counter_cache => true

  before_create :check_if_already_shared_by_user

  private
  def check_if_already_shared_by_user
    false if Share.exists?(user_id: user_id, post_id: post_id)
  end
end
