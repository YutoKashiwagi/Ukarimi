FactoryBot.define do
  factory :question do
    title { 'Title' }
    content { "MyString" }
    association :user
    solved { 0 }
  end
end
