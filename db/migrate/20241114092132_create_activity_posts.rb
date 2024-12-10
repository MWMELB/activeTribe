class CreateActivityPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_posts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
