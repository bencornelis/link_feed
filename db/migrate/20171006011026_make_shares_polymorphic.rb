class MakeSharesPolymorphic < ActiveRecord::Migration
  def change
    change_table :shares do |t|
      t.remove  :post_id

      t.integer :shareable_id
      t.string  :shareable_type
    end

    add_index :shares, [:shareable_type, :shareable_id]
  end
end
