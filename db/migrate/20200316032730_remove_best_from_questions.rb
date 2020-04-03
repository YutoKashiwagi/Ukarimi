class RemoveBestFromQuestions < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :questions, :answers
    remove_index :questions, :best
    remove_column :questions, :best, :bigint
  end
end
