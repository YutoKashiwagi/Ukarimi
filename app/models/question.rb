class Question < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :content,
            presence: true,
            length: { maximum: 1000 }
  validates :title,
            presence: true,
            length: { maximum: 50 }
end
