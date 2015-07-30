class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings
  before_save :remove_spaces

  scope :recent,  -> (number) { order("created_at desc").limit(number) }
  scope :popular, -> (number) { order("posts_count desc").limit(number) }

  def self.find_or_create_by_name(tag_name)
    tag = Tag.find_by(name: tag_name.split(" ").join)
    unless tag
      tag = Tag.create(name: tag_name)
    end
    tag
  end

  def with_hash
    if name[0] == "#"
      name
    else
      "#" + name
    end
  end

  private

  def remove_spaces
    self.name = name.split(" ").join
  end
end
