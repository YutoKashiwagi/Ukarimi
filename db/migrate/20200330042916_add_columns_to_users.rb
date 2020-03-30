class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile, :text
    add_column :users, :bunri, :integer, default: 0, limit: 1
    add_index :users, :bunri
  end
end
