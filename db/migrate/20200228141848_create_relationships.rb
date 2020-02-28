class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :followee_id
      t.integer :follower_id

      t.timestamps
      t.index [:follower_id, :followee_id], unique: true
      t.index :follower_id
      t.index :followee_id
    end
  end
end
