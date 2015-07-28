class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings
  before_save :prepend_hash
  before_save :remove_spaces

  def self.find_by_tag_name(tag_name)
    unless tag_name[0] == "#"
      tag_name = "#" + tag_name
    end
    find_by(name: tag_name)
  end


  private
  def prepend_hash
    unless name[0] == "#"
      self.name = "#" + name
    end
  end

  def remove_spaces
    self.name = name.split(" ").join
  end
end
