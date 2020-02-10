FactoryBot.define do
  factory :question do
    content { "MyString" }
    user { create(:user) }
  end
end
