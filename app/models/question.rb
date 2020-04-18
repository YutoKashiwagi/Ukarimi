class Question < ApplicationRecord
  include Liked
  include Taggable
  include CommonScope
  include Commentable

  belongs_to :user

  has_many :notifications, dependent: :destroy
  has_many :answers,  dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes,    as: :likable,     dependent: :destroy

  # ストック周り
  has_many :stocks,        dependent: :destroy
  has_many :stocked_users, through: :stocks, source: :user

  # カテゴリー周り
  has_many :tag_relationships, as: :taggable, dependent: :destroy
  has_many :categories, through: :tag_relationships, source: :category

  # ベストアンサー周り
  has_one :q_and_a_relationship, dependent: :destroy
  has_one :best_answer, through: :q_and_a_relationship, source: :answer

  # バリデーション
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
  validates :title,   presence: true, length: { maximum: 50 }

  def has_best_answer?
    best_answer.present?
  end

  def decide_best_answer(answer)
    if answers.include?(answer) && best_answer.blank?
      self.best_answer = answer
      update_attribute(:solved, 1)
    end
  end

  # 通知周り
  def create_notification_best_answer(answer)
    notification = user.active_notifications.new(
      answer: answer,
      visitor: user,
      visited: answer.user,
      action: 'best_answer'
    )
    if notification.valid? && notification.visitor != notification.visited
      notification.save
    end
  end

  # N+1対策用
  def self.all_includes
    includes(:best_answer, :user, :tag_relationships, :categories)
  end

  # 関連質問
  def related_questions
    related_categories_ids = "SELECT category_id
                             FROM tag_relationships
                             WHERE taggable_type = :question AND taggable_id = :self_id"
    related_questions_ids = "SELECT taggable_id
                             FROM tag_relationships
                             WHERE taggable_type = :question
                              AND category_id IN (#{related_categories_ids})
                              AND taggable_id != :self_id"
    Question.where("id IN (#{related_questions_ids})",
                   question: 'Question',
                   self_id: id).distinct.recent
  end
end
