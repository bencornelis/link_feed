class AddIndexesToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :user_id
    add_index :posts, :created_at
  end
end
