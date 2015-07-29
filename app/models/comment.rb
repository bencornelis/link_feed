class Comment < ActiveRecord::Base
  validates_presence_of :text

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  has_many :comments, :as => :commentable
  belongs_to :user
  belongs_to :post, :counter_cache => true

  before_save :attach_to_post

  delegate :username, to: :user

  def edited?
    created_at != updated_at
  end

  private
  def attach_to_post
    if commentable_type == "Comment"
      self.post_id = commentable.post_id
    else
      self.post_id = commentable.id
    end
  end
end
