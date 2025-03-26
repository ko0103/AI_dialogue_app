FactoryBot.define do
  factory :user do
    name { "らんてくん" }
    sequence(:email) { |n| "runteq_#{n}@example.com" }
    password { "runteq" }
    password_confirmation { "runteq" }
  end
end
