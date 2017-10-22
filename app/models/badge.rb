class Badge < ActiveRecord::Base
  belongs_to :badge_giver, class_name: 'User'

  scope :given,     -> { where(given: true) }
  scope :not_given, -> { where(given: false) }
end
