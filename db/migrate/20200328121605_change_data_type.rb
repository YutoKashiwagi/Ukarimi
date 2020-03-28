class ChangeDataType < ActiveRecord::Migration[5.2]
  def change
    change_column :questions, :content, :text
  end
end
