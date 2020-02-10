class Question < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :content,
            presence: true,
            length: { maximum: 1000 }
end
