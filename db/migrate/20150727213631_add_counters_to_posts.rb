class AddCountersToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :comments_count, :integer, default: 0
    add_column :posts, :shares_count, :integer, default: 0
  end
end
