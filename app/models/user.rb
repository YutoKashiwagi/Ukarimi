class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # mount_uploader
  mount_uploader :profile_image, ProfileImageUploader

  enum role: {
    normal: 0,
    admin: 1,
    guest: 2,
  }

  enum bunri: {
    undecided: 0,
    bunkei: 1,
    rikei: 2,
  }

  has_many :posts,     dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :comments,  dependent: :destroy
  has_many :likes,     dependent: :destroy
  has_many :answers,   dependent: :destroy
  has_many :answered_questions, through: :answers, source: :question

  # ストック周り
  has_many :stocks, dependent: :destroy
  has_many :stocked_questions, through: :stocks, source: :question

  # タグ、カテゴリー周り
  has_many :tag_relationships, as: :taggable,               dependent: :destroy
  has_many :categories,        through: :tag_relationships, source: :category

  # フォロー周り
  has_many :active_relationships,  foreign_key: :follower_id,       class_name: 'Relationship', dependent: :destroy
  has_many :followees,             through: :active_relationships,  source: :followee
  has_many :passive_relationships, foreign_key: :followee_id,       class_name: 'Relationship', dependent: :destroy
  has_many :followers,             through: :passive_relationships, source: :follower

  # 通知周り
  has_many :active_notifications,  class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # バリデーション
  validates :name,    presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 400 }
  validates :email,   length: { maximum: 256 }

  # ストック周り
  def stock(question)
    unless stocked?(question)
      stocked_questions << question
      create_notification_stock(question)
    end
  end

  def unstock(question)
    stocks.find_by(question_id: question.id).destroy! if stocked?(question)
  end

  def stocked?(question)
    stocked_questions.include?(question)
  end

  # フォロー周り
  def follow(other_user)
    return if self == other_user
    unless following?(other_user)
      followees << other_user
      create_notification_follow(other_user)
    end
  end

  def unfollow(other_user)
    active_relationships.find_by(followee_id: other_user.id).destroy! if following?(other_user)
  end

  def following?(other_user)
    followees.include?(other_user)
  end

  # タグ、カテゴリー周り
  def follow_category(category)
    categories << category unless following_category?(category)
  end

  def unfollow_category(category)
    tag_relationships.find_by(category_id: category.id).destroy if following_category?(category)
  end

  def following_category?(category)
    categories.include?(category)
  end

  # 通知周り
  def create_notification_follow(followee)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ?', id, followee.id, 'follow'])
    if temp.blank?
      notification = active_notifications.new(
        visited: followee,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def create_notification_answer(answer)
    notification = active_notifications.new(
      answer: answer,
      visited: answer.question.user,
      action: 'answer'
    )
    if notification.visitor == notification.visited
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def create_notification_stock(question)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ?', id, question.user.id, 'stock'])
    if temp.blank?
      notification = active_notifications.new(
        question: question,
        visited: question.user,
        action: 'stock'
      )
      if notification.visitor == notification.visited
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def has_new_notifications?
    passive_notifications.where(checked: false).present?
  end

  def save_notification_comment(comment, visited_id)
    notification = active_notifications.new(
      comment: comment,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor == notification.visited
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  # ランキング周り
  def self.create_ranking(obj)
    User.find(obj.group(:user_id).order('count(user_id) desc').limit(10).pluck(:user_id))
  end

  # ゲストユーザー周り
  def self.guest
    find_by(email: 'guest@guest.com') || find_or_create_by(name: 'ゲスト', role: :guest) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.email = "guest_#{Time.now.to_i}#{rand(100)}@example.com"
    end
  end

  # フィード
  def followee_items(obj)
    obj.recent.where("user_id IN (?)", followee_ids)
  end

  def mycategory_items(obj)
    # QUestion, Postのidを取得するためのサブクエリ
    myitems_ids = "SELECT taggable_id
                   FROM tag_relationships
                   WHERE taggable_type = :obj_class AND category_id IN (:mycategories_ids)"
    obj.where("id IN (#{myitems_ids})", obj_class: obj.name, mycategories_ids: category_ids).recent
  end
end
