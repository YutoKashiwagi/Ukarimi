class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user_id,     presence: true
  validates :question_id, presence: true
end
