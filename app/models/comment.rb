class Comment < ActiveRecord::Base
  validates_presence_of :text

  belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable
  belongs_to :user

  delegate :username, to: :user

end
