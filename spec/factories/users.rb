FactoryBot.define do
  factory :user do
    name { 'Test User' }
    password { 'password' }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
