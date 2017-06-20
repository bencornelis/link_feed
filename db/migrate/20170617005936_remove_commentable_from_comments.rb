class RemoveCommentableFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
  end
end
