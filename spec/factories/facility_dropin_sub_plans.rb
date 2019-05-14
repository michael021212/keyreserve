FactoryBot.define do
  factory :facility_dropin_sub_plan do
    facility_dropin_plan
    name { 'ドロップインサププラン' }
    starting_time { '12:00:00' }
    ending_time { '18:00:00' }
    price { 1000 }
  end
end
