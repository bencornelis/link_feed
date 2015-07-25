class User < ActiveRecord::Base
  attr_accessor :password

  validates_presence_of :username
  validates_presence_of :email

  validates_confirmation_of :password
  before_save :encrypt_password

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

  private
  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

end
