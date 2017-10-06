class AddSharesCountToComments < ActiveRecord::Migration
  def change
    add_column :comments, :shares_count, :integer, default: 0
  end
end
