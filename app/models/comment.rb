class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
