class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings

  scope :recent,  -> (number) { order("created_at desc").limit(number) }
  scope :popular, -> (number) { order("posts_count desc").limit(number) }

  def with_hash
    name[0] == "#" ? name : "#" + name
  end
end
