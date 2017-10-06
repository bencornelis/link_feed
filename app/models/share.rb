class Share < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :shareable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: [:shareable_id, :shareable_type] }
end
