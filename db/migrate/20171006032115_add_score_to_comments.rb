class AddScoreToComments < ActiveRecord::Migration
  def change
    add_column :comments, :score, :float, default: 0.0
  end
end
