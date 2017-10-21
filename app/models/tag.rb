class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings

  scope :recent,  -> (number) { order("created_at desc").limit(number) }
  scope :popular, -> (number) { order("posts_count desc").limit(number) }
  scope :search,  -> (term)   { where('name LIKE ?', "%#{term}%") }

  def with_hash
    name[0] == "#" ? name : "#" + name
  end
end
