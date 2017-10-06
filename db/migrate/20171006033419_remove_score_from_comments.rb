class RemoveScoreFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :score
  end
end
