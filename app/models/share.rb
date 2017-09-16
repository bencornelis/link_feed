class Share < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :post, counter_cache: true

  validates :user_id, uniqueness: { scope: :post_id }
end
