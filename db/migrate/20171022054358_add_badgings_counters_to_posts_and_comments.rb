class AddBadgingsCountersToPostsAndComments < ActiveRecord::Migration
  def change
    add_column :posts, :badgings_count, :integer, default: 0
    add_column :comments, :badgings_count, :integer, default: 0
  end
end
