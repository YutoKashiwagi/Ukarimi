class TagRelationship < ApplicationRecord
  belongs_to :category
  belongs_to :taggable, polymorphic: true
end
