class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings
  before_save :remove_spaces

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
