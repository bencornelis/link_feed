class ChangeShares < ActiveRecord::Migration
  def change
    remove_column :shares, :shareable_id
    add_column :shares, :post_id, :integer
  end
end
