class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end
  end
end
