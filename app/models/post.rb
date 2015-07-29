class Post < ActiveRecord::Base
  attr_accessor :tag1_name, :tag2_name

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

  scope :recent,             -> { order("created_at DESC") }
  scope :most_comments,      -> { order("comments_count desc") }
  scope :most_shares,        -> { order("shares_count desc") }
  scope :with_shares,        -> { where("shares_count > 0")}
  scope :find_with_comments, -> (id) { includes(:comments).find(id) }

  def self.sorted_by(sort_option)
    case sort_option
    when "time"
      recent
    when "comments"
      most_comments
    when "shares"
      most_shares
    else
      all
    end
  end

  def self.tagged_with(name)
    name ? Tag.find_by_name(name).posts : all
  end

  def self.filter_global(options)
    includes(:tags, :user).tagged_with(options[:tag])
                          .sorted_by(options[:sort])
                          .paginate(page: options[:page], per_page: 7)
  end

  def self.filter_feed(user)
    user_followee_ids = user.followees.pluck(:id).to_a
    includes(:tags, :user)
        .select("posts.id",
                "posts.url",
                "posts.title",
                "posts.user_id",
                "count(shares.id) AS followee_shares_count")
        .joins(:shares)
        .where("shares.user_id IN (?)", user_followee_ids)
        .group("posts.id")
        .order("followee_shares_count desc")
  end

  def text_only?
    url.empty?
  end

  def edited?
    created_at != updated_at
  end

  def first_tag_name
    tags.first.with_hash
  end

  def second_tag_name
    tags.last.with_hash
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
      tag = Tag.find_by_name(tag_name)
      unless tag
        tag = Tag.create(name: tag_name)
      end
      tags << tag
    end
  end
end
