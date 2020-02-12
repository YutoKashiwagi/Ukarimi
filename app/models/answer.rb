class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  # バリデーション
  validates :content, 
            presence: true,
            length: { maximum: 1000 }
end
