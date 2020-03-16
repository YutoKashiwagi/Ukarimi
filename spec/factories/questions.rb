FactoryBot.define do
  factory :question do
    title { 'Title' }
    content { "MyString" }
    user { create(:user) }
  end
end
