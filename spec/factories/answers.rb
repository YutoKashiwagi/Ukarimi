FactoryBot.define do
  factory :answer do
    content { "MyText" }
    user { nil }
    question { nil }
  end
end
