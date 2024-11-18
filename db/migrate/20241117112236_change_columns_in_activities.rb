class ChangeColumnsInActivities < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :sport, :string
    add_column :activities, :capacity, :integer
    remove_column :activities, :description, :string
    add_column :activities, :description, :text
  end
end
