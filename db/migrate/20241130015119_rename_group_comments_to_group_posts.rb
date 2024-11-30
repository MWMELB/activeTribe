class RenameGroupCommentsToGroupPosts < ActiveRecord::Migration[7.1]
  def change
    rename_table :group_comments, :group_posts
  end
end
