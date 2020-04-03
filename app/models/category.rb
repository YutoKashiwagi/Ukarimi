class Category < ApplicationRecord
  has_many :tag_relationships
  has_many :questions, through: :tag_relationships, source: :taggable, source_type: 'Question'
  has_many :posts, through: :tag_relationships, source: :taggable, source_type: 'Post'
  has_many :users, through: :tag_relationships, source: :taggable, source_type: 'User'
end
