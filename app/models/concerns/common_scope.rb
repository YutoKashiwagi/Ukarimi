module CommonScope
  extend ActiveSupport::Concern
  included do
    scope :recent, -> { order(id: :desc) }
  end
end
