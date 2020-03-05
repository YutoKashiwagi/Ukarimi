class Category < ApplicationRecord
  has_many :tag_relationships
  has_many :questions, through: :tag_relationships, source: :taggable, source_type: 'Question'
end
