FactoryBot.define do
  factory :answer do
    content { "answer content" }
    association :user
    association :question
  end
end
