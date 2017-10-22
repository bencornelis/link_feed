class AddBadgeReceiverToBadgings < ActiveRecord::Migration
  def change
    add_column :badgings, :badge_receiver_id, :integer
  end
end
