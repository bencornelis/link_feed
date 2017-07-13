class AddIndexesToTags < ActiveRecord::Migration
  def change
    add_index :tags, :created_at
    add_index :tags, :posts_count
  end
end
