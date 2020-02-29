FactoryBot.define do
  factory :comment do
    content { "MyText" }
    user { create(:user) }
    commentable { create(:question) }
  end
end
