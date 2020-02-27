class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  # バリデーション
  validates :content,
            presence: true,
            length: { maximum: 1000 }

  def best_answer?(question)
    self == question.best_answer&.answer
  end
end
