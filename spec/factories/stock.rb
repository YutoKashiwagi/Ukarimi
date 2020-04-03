FactoryBot.define do
  factory :stock do
    user { nil }
    question { create(:question) }
  end
end
