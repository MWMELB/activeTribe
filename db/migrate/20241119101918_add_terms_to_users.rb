class AddTermsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :terms, :boolean, default: false
  end
end
