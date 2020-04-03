class Post < ApplicationRecord
  include Taggable
  include Liked
  include CommonScope
  include Commentable

  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy
  has_many :tag_relationships, as: :taggable, dependent: :destroy
  has_many :categories, through: :tag_relationships, source: :category

  validates :content,
            presence: true,
            length: { maximum: 1000 }
end
