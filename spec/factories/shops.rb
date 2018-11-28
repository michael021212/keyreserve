FactoryBot.define do
  factory :shop do
    corporation
    sequence(:name) { |n| "店舗#{n}" }
    postal_code { "1234567" }
    address { "渋谷区渋谷1-1-1" }
    lat { "35.66641170" }
    lon { "139.75746240" }
    tel { "09012345678" }
    opening_time { "00:00:00" }
    closing_time { "23:59:59" }
  end
end
