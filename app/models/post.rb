class Post < ActiveRecord::Base
  resourcify

  DEFAULT_PER_PAGE = 10

  validates :title, presence: true

  attr_accessor :tag_names
  after_save :assign_tags

  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :users_shared_by, through: :shares, source: :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :badgings, as: :badgeable
  has_many :badges, through: :badgings

  delegate :username, to: :user

  scope :by_time, -> { order("posts.created_at desc") }
  scope :with_shares, -> { where("posts.shares_count > 0") }
  scope :find_with_comments, -> (id) { includes(:comments).find(id) }
  scope :with_tag, -> (tag_name) { joins(:tags).where(tags: {name: tag_name}) }

  def self.filter(options)
    scope = options[:tag] ? with_tag(options[:tag]) : all
    scope.paginate(page: options[:page],
                   per_page: options.fetch(:per_page, DEFAULT_PER_PAGE))
  end

  def text_only?
    url.empty?
  end

  def edited?
    created_at != updated_at
  end

  private
  def assign_tags
    return unless @tag_names

    # @tag_names actually contains existing tag ids and new tag names
    # e.g. ['2', 'newtag']
    self.tags = @tag_names.map do |name|
      name =~ /^\d+$/ ? Tag.find(name) : Tag.create(name: name)
    end
  end
end
