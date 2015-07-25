class Post < ActiveRecord::Base
  validates_presence_of :title
  before_save :tag_count_within_bounds

  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tags
  has_many :shares
  has_many :users_shared_by, through: :shares, source: :user

  # constants
  MAX_TAG_NUMBER = 2

  private
  def tag_count_within_bounds
    if tags.size > MAX_TAG_NUMBER
      errors.add(:base, "Too many tags")
      false
    end
  end
end
