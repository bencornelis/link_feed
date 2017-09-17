class Comment < ActiveRecord::Base
  validates :text, presence: true
  delegate :username, to: :user

  has_ancestry
  belongs_to :user
  belongs_to :post, counter_cache: true

  scope :recent, -> { order("created_at desc") }

  def edited?
    created_at != updated_at
  end

  def post_title
    post.title
  end
end
