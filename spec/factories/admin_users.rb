FactoryBot.define do
  factory :admin_user do
    sequence(:name) { |n| "管理者#{n}"}
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
  end
end
