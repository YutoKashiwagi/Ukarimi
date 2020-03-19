FactoryBot.define do
  factory :post do
    user { create(:user) }
    content { "MyText" }
  end
end
