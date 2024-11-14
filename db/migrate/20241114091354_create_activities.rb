class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.string :photo
      t.string :type
      t.string :description
      t.string :location
      t.integer :price
      t.datetime :start
      t.time :duration
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
