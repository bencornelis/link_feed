class AddIndexesToTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, :tag_id
    add_index :taggings, :post_id
  end
end
