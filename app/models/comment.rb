class Comment < ActiveRecord::Base
  validates :text, presence: true
  delegate :username, to: :user

  has_ancestry
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :users_shared_by, through: :shares, source: :user
  belongs_to :user
  belongs_to :post, counter_cache: true

  scope :recent,   -> { order("created_at desc") }
  scope :by_score, -> { order("#{score_sql} desc") }

  def self.arrange_by_score
    arrange(order: "#{score_sql} desc")
  end

  def edited?
    created_at != updated_at
  end

  def post_title
    post.title
  end

  def parent_type
    root? ? :post : :comment
  end

  private

  def self.score_sql
    '(shares_count - 1)/POWER(EXTRACT(EPOCH FROM (NOW() - created_at)) + 2, 1.8)'
  end
end
