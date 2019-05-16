FactoryBot.define do
  factory :facility_temporary_plan_price do
    facility_temporary_plan
    starting_time { Time.zone.local(2019, 1, 1, 10, 10) }
    ending_time { Time.zone.local(2019, 1, 1, 10, 11) }
    price { 1000 }
  end
end
