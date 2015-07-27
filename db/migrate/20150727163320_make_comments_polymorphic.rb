class MakeCommentsPolymorphic < ActiveRecord::Migration
  def change
    remove_column :comments, :post_id
    add_column :comments, :commentable_id, :integer
    add_column :comments, :comentable_type, :string

    add_index :comments, :commentable_id
  end
end
