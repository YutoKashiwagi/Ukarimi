class AddColumnsToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :title, :text
  end
end
