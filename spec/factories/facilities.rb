FactoryBot.define do
  factory :facility do
    shop
    sequence(:name) { |n| "施設#{n}"}
    address { "目黒区目黒1-1-1" }
    lat { "35.66641170" }
    lon { "139.75746240" }
    facility_type { :conference_room }
  end
end
