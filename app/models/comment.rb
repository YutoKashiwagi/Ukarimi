class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
