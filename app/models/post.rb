class Post < ActiveRecord::Base
  attr_accessor :tag1_name, :tag2_name

  validates_presence_of :title
  before_save :add_tags

  belongs_to :user
  has_many :comments, :as => :commentable
  has_many :shares
  has_many :users_shared_by, through: :shares, source: :user
  has_many :taggings
  has_many :tags, through: :taggings

  delegate :username, to: :user

  scope :recent, -> (count) { order("created_at DESC").limit(count) }

  def text_only?
    url.empty?
  end

  def first_tag_name
    tags.first.name
  end

  def second_tag_name
    tags.last.name
  end

  # Statistics
  def share_count
    shares.size
  end

  def comment_count
    comments.size
  end

  private
  def add_tags
    [tag1_name, tag2_name].each do |tag_name|
      next unless tag_name
      tag = Tag.find_or_create_by(name: tag_name)
      tags << tag
    end
  end
end
