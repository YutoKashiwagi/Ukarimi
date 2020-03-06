class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # ストック周り
  has_many :stocks, dependent: :destroy
  has_many :stocked_questions, through: :stocks, source: :question, dependent: :destroy

  #  タグ、カテゴリー周り
  has_many :tag_relationships, as: :taggable, dependent: :destroy
  has_many :categories, through: :tag_relationships, source: :category

  # フォロー周り
  has_many :active_relationships, foreign_key: :follower_id, class_name: 'Relationship', dependent: :destroy
  has_many :followees, through: :active_relationships, source: :followee
  has_many :passive_relationships, foreign_key: :followee_id, class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # バリデーション
  validates :name,
            presence: true,
            length: { maximum: 20 }

  # ストック周り
  def stock(question)
    stocked_questions << question unless stocked?(question)
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

    followees << other_user unless following?(other_user)
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
end
