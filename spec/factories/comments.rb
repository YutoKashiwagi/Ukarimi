FactoryBot.define do
  factory :comment do
    content { "MyText" }
    association :user
    commentable { create(:question) }
  end
end
