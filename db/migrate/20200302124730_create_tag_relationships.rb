class CreateTagRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_relationships do |t|
      t.references :category, foreign_key: true
      t.references :taggable, polymorphic: true

      t.timestamps
    end
  end
end
