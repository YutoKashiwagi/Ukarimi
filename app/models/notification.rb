class Notification < ApplicationRecord
  include CommonScope

  belongs_to :answer,   optional: true
  belongs_to :comment,  optional: true
  belongs_to :question, optional: true
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'

  validates :visitor_id, presence: true
  validates :visited_id, presence: true
end
