class RemoveColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :shares_received_since_last_badge
  end
end
