FactoryBot.define do
  factory :user do
    name { 'tester' }
    sequence(:email) { |n| "tester#{n}@tester.com" }
    password { 'password' }
  end
end
