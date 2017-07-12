class Post < ActiveRecord::Base
  resourcify
  validates_presence_of :title

  attr_writer :tag_names
  after_save :assign_tags

  belongs_to :user, counter_cache: true
  has_many :comments
  has_many :shares
  has_many :users_shared_by, through: :shares, source: :user
  has_many :taggings
  has_many :tags, through: :taggings

  delegate :username, to: :user

  scope :by_time,             -> { order("posts.created_at desc") }
  scope :with_shares,         -> { where("posts.shares_count > 0")}
  scope :find_with_comments,  -> (id)  { includes(:comments).find(id) }
  scope :with_tag,            -> (tag_name) { joins(:tags).where(tags: {name: tag_name}) if tag_name }
  scope :filter_tag_and_page, -> (tag, page, per_page) { with_tag(tag).paginate(page: page, per_page: per_page) }

  def text_only?
    url.empty?
  end

  def edited?
    created_at != updated_at
  end

  def tag_names
    @tag_names ||= tags.map(&:name).join(" ")
  end

  private
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by(name: name)
      end
    end
  end
end
