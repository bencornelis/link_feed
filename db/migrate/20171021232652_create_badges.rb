class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.references :badge_giver
      t.boolean :given, default: false

      t.timestamps null: false
    end
  end
end
