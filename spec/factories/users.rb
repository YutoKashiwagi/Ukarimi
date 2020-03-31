FactoryBot.define do
  factory :user do
    name { 'tester' }
    sequence(:email) { |n| "tester#{n}@tester.com" }
    password { 'password' }
    profile { nil }
    bunri { 0 }
    role { 0 }
  end
end
