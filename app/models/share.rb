class Share < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :shareable, polymorphic: true, counter_cache: true
  belongs_to :share_receiver, class_name: 'User',
                              counter_cache: :shares_received_count

  validates :user_id, uniqueness: { scope: [:shareable_id, :shareable_type] }
end
