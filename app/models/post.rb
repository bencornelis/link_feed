class Post < ActiveRecord::Base
  resourcify
  validates_presence_of :title

  belongs_to :user, counter_cache: true
  has_many :top_level_comments, class_name: "Comment", :as => :commentable
  has_many :comments
  has_many :shares
  has_many :users_shared_by, through: :shares, source: :user
  has_many :taggings
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :taggings

  delegate :username, to: :user

  scope :recent,             -> { order("posts.created_at DESC") }
  scope :most_comments,      -> { order("posts.comments_count desc") }
  scope :most_shares,        -> { order("posts.shares_count desc") }
  scope :with_shares,        -> { where("posts.shares_count > 0")}
  scope :find_with_comments, -> (id) { includes(:comments).find(id) }

  def text_only?
    url.empty?
  end

  def edited?
    created_at != updated_at
  end
end
