class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :stocked_questions, through: :stocks, source: :question

  # バリデーション
  validates :name,
            presence: true,
            length: { maximum: 20 }

  def stock(question)
    stocked_questions << question unless stocked?(question)
  end

  def unstock(question)
    stocks.find_by(question_id: question.id).destroy! if stocked?(question)
  end

  def stocked?(question)
    stocked_questions.include?(question)
  end
end
