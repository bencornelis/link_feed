class AddIndexesToShares < ActiveRecord::Migration
  def change
    add_index :shares, :post_id
    add_index :shares, :user_id
  end
end
