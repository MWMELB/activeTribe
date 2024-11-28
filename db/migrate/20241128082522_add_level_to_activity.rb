class AddLevelToActivity < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :level, :integer
  end
end
