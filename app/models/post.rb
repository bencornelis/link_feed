class Post < ActiveRecord::Base
  validates_presence_of :title
  before_save :tag_count_within_bounds

  belongs_to :user
  has_many :comments
  has_many :shares
  has_many :users_shared_by, through: :shares, source: :user

  scope :recent, -> (count) { order("created_at DESC").limit(count) }

  # constants
  MAX_TAG_COUNT = 2

  # Statistics
  def share_count
    shares.size
  end

  def comment_count
    comments.size
  end

  private
  # def tag_count_within_bounds
  #   if tags.size > MAX_TAG_COUNT
  #     errors.add(:base, "Too many tags")
  #     false
  #   end
  # end
end
