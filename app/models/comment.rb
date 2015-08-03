class Comment < ActiveRecord::Base
  validates_presence_of :text

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  has_many :top_level_comments, class_name: "Comment", :as => :commentable
  belongs_to :user
  belongs_to :post, :counter_cache => true

  before_save :attach_to_post

  delegate :username, to: :user

  def edited?
    created_at != updated_at
  end

  def nested?
    commentable_type == "Comment"
  end

  def post_title
    post.title
  end

  private
  def attach_to_post
    if nested?
      self.post_id = commentable.post_id
    else
      self.post_id = commentable_id
    end
  end
end
