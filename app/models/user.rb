class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  rolify

  validates :username, presence: true, uniqueness: true
  validates :email, email_format: true

  has_many :posts
  has_many :comments
  has_many :shares
  has_many :shared_posts, through: :shares, source: :post

  has_many :followee_follows, class_name: "Follow", foreign_key: :followee_id
  has_many :followers, through: :followee_follows

  has_many :follower_follows, class_name: "Follow", foreign_key: :follower_id
  has_many :followees, through: :follower_follows

  def following?(other_user)
    followees.exists?(other_user.id)
  end

  def shared?(post)
    shared_posts.exists?(post.id)
  end

  def recent_posts(number = 5)
    posts.limit(number)
  end

  def recent_shared_posts(number = 5)
    shared_posts.limit(number)
  end

  def recent_comments(number = 5)
    comments.limit(number)
  end

  def followee_follow(other_user)
    followee_follows.find_by(follower_id: other_user.id)
  end
end
