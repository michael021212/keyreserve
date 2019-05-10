FactoryBot.define do
  factory :facility do
    shop
    sequence(:name) { |n| "施設#{n}"}
    address { "目黒区目黒1-1-1" }
    facility_type { :conference_room }
    max_num { 100 }
    description { '意識高い系の人たちが集まるオフィスなんだぜ' }
    lat { "35.66641170" }
    lon { "139.75746240" }
  end
end
