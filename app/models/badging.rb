class Badging < ActiveRecord::Base
  belongs_to :badge
  belongs_to :badgeable, polymorphic: true, counter_cache: true
  belongs_to :badge_receiver, class_name: 'User'
end
