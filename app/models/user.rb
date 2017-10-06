class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  rolify

  validates :username, presence: true, uniqueness: true
  validates :email, email_format: true

  has_many :posts
  has_many :comments
  has_many :shares
  has_many :shared_posts, through: :shares,
                          source: :shareable,
                          source_type: 'Post'

  has_many :shared_comments, through: :shares,
                             source: :shareable,
                             source_type: 'Comment'

  has_many :followee_follows, class_name: "Follow", foreign_key: :followee_id
  has_many :followers, through: :followee_follows

  has_many :follower_follows, class_name: "Follow", foreign_key: :follower_id
  has_many :followees, through: :follower_follows

  def following?(other_user)
    followees.exists?(other_user.id)
  end

  def shared_post?(post)
    shared_posts.exists?(post.id)
  end

  def shared_comment?(comment)
    shared_comments.exists?(comment.id)
  end

  def recent_posts(count)
    posts.limit(count)
  end

  def recent_shared_items(count)
    shares
      .order('created_at desc')
      .limit(count)
      .map(&:shareable)
  end

  def recent_comments(count)
    comments.limit(count)
  end

  def followee_follow(other_user)
    followee_follows.find_by(follower_id: other_user.id)
  end
end
