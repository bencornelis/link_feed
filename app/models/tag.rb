class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings
  before_save :prepend_hash
  before_save :remove_spaces


  private
  def prepend_hash
    unless name.first == "#"
      self.name = "#" + name
    end
  end

  def remove_spaces
    self.name = name.split(" ").join
  end
end
