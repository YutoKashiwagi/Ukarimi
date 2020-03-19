class AddQuestionIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :question_id, :integer
    add_index :notifications, :question_id
  end
end
