class AddSharesReceivedCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shares_received_count, :integer, default: 0
  end
end
