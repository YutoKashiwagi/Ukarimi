FactoryBot.define do
  factory :question do
    title { 'Title' }
    content { "MyString" }
    user { create(:user) }
    solved { 0 }
  end
end
