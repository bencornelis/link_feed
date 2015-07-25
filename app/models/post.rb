class Post < ActiveRecord::Base
  validates_presence_of :title

  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tags
  has_many :shares
  has_many :users_shared_by, through: :shares, source: :user
end
