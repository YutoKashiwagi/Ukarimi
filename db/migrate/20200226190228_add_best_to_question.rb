class AddBestToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :best, :bigint
    add_foreign_key :questions, :answers, column: :best
  end
end
