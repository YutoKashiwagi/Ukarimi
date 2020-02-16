FactoryBot.define do
  factory :answer do
    content { "answer content" }
    user { create(:user) }
    question { create(:question) }
  end
end
