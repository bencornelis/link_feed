class Post < ActiveRecord::Base
  attr_accessor :tag1_name, :tag2_name
  resourcify

  validates_presence_of :title
  before_save :add_tags

  belongs_to :user
  has_many :top_level_comments, class_name: "Comment", :as => :commentable
  has_many :comments
  has_many :shares
  has_many :users_shared_by, through: :shares, source: :user
  has_many :taggings
  has_many :tags, through: :taggings

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

  def first_tag
    tags.first
  end

  def second_tag
    tags.last
  end

  private
  def add_tags
    [tag1_name, tag2_name].each do |tag_name|
      next unless tag_name
      tag = Tag.find_or_create_by_name(tag_name)
      tags << tag
    end
  end
end
