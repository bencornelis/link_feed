class Comment < ActiveRecord::Base
  validates_presence_of :text

  has_ancestry
  belongs_to :user
  belongs_to :post, counter_cache: true

  delegate :username, to: :user

  def edited?
    created_at != updated_at
  end
  
  def post_title
    post.title
  end
end
