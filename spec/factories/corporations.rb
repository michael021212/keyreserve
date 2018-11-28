FactoryBot.define do
  factory :corporation do
    sequence(:name) { |n| "企業#{n}" }
    sequence(:kana) { |n| "きぎょう#{n}" }
    tel { "09012345678" }
    postal_code { "123-4567" }
    address { "渋谷区渋谷1-1-1" }
    note { "メモメモ" }

    trait :with_token do
      token { SecureRandom.hex(8) }
    end
  end
end
