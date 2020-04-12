class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likable, polymorphic: true

  validates :user_id, presence: true
end
