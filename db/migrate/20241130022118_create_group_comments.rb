class CreateGroupComments < ActiveRecord::Migration[7.1]
  def change
    create_table :group_comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :group_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
