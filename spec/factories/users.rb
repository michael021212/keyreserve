FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "sample#{n}@example.com" }
    sequence(:name) { |n| "ユーザ#{n}" }
    password { 'password' }
    tel { "09012345678" }
    state { [:registered, :activated].sample }
    payway { [:creditcard, :invoice].sample }
    user_type { :personal }

    trait :with_corporation do
      state { :parent_corporation }
      corporation
      parent_id { corporation.id }
    end

    trait :corporate_admin do
      user_type { :corporate_admin }
    end
  end
end
