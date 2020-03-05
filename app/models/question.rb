class Question < ApplicationRecord
  include Liked
  include Taggable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :stocked_users, through: :stocks, source: :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy
  has_many :tag_relationships, as: :taggable, dependent: :destroy
  has_many :categories, through: :tag_relationships, source: :category

  # バリデーション
  validates :content,
            presence: true,
            length: { maximum: 1000 }
  validates :title,
            presence: true,
            length: { maximum: 50 }

  def has_best_answer?
    best.present?
  end

  def best_answer
    answers.find(best) if best.present?
  end
end
