class User < ActiveRecord::Base
  rolify
  attr_accessor :password

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :username
  validates_presence_of :email

  validates_confirmation_of :password
  before_save :encrypt_password
  before_save :assign_robot_avatar

  has_many :posts
  has_many :comments
  has_many :shares
  has_many :shared_posts, through: :shares, source: :post

  has_many :followee_follows, class_name: "Follow", foreign_key: :followee_id
  has_many :followers, through: :followee_follows

  has_many :follower_follows, class_name: "Follow", foreign_key: :follower_id
  has_many :followees, through: :follower_follows

  def self.authenticate(username, password)
    user = User.find_by(username: username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    end
  end

  def is_following?(other_user)
    followees.include?(other_user)
  end

  def has_shared?(post)
    shared_posts.exists?(post.id)
  end

  def recent_posts(number = 5)
    posts.includes(:tags).limit(number)
  end

  def recent_shared_posts(number = 5)
    shared_posts.includes(:tags).limit(number)
  end

  def recent_comments(number = 5)
    comments.includes(:commentable, :post).limit(number)
  end

  private
  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def assign_robot_avatar
    self.avatar = Faker::Avatar.image
  end
end
