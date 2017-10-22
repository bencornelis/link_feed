class AddShareReceiverToShares < ActiveRecord::Migration
  def change
    add_column :shares, :share_receiver_id, :integer
  end
end
