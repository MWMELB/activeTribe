class ChangeTypeInActivity < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :type, :string
    add_column :activities, :sport, :string
  end
end
