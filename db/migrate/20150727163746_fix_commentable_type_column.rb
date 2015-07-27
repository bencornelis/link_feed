class FixCommentableTypeColumn < ActiveRecord::Migration
  def change
    rename_column :comments, :comentable_type, :commentable_type
  end
end
