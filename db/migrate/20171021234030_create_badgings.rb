class CreateBadgings < ActiveRecord::Migration
  def change
    create_table :badgings do |t|
      t.references :badge
      t.references :badgeable, polymorphic: true
      
      t.timestamps null: false
    end
  end
end
