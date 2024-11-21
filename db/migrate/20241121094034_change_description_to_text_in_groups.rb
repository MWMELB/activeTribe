class ChangeDescriptionToTextInGroups < ActiveRecord::Migration[7.1]
  def change
    remove_column :groups, :description, :string
    add_column :groups, :description, :text
    add_column :groups, :photo, :string
  end
end
