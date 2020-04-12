class TagRelationship < ApplicationRecord
  belongs_to :category
  belongs_to :taggable, polymorphic: true

  validates :category_id, presence: true
end
