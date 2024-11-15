class ChangeDurationInActivity < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :duration, :time
    add_column :activities, :duration, :integer
  end
end
