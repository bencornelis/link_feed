class Comment < ActiveRecord::Base
  validates_presence_of :text

  belongs_to :commentable, :polymorphic => true
  has_many :top_level_comments, class_name: "Comment", :as => :commentable
  belongs_to :user
  belongs_to :post, :counter_cache => true

  before_save :attach_to_post
  before_save :increment_parent_comments_counters

  delegate :username, to: :user

  def edited?
    created_at != updated_at
  end

  def nested?
    parent_comment != nil
  end

  def parent_comment
    commentable if commentable_type == "Comment"
  end

  def has_comments?
    comments_count != 0
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

  def increment_parent_comments_counters
    if nested?
      parent = parent_comment
      while parent
        parent.update_column(:comments_count, parent.comments_count + 1)
        parent = parent.parent_comment
      end
    end
  end
end
