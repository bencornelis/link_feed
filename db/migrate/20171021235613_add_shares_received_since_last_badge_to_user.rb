class AddSharesReceivedSinceLastBadgeToUser < ActiveRecord::Migration
  def change
    add_column :users, :shares_received_since_last_badge, :integer, default: 0
  end
end
