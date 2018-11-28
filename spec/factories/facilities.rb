FactoryBot.define do
  factory :facility do
    shop
    corporation
    sequence(:name) { |n| "施設#{n}"}
    postal_code { "123-4567" }
    address { "目黒区目黒1-1-1" }
    lat { "35.66641170" }
    lon { "139.75746240" }
    tel { "09012345678" }
    opening_time { "00:00:00" }
    closing_time { "23:59:59" }
  end
end
