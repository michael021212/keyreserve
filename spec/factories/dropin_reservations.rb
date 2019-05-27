FactoryBot.define do
  factory :dropin_reservation do
    facility
    user
    payment
    facility_dropin_plan
    facility_dropin_sub_plan
    facility_key
    checkin { Time.zone.now - 2.days }
    checkout { Time.zone.now - 1.days }
    state { [:unconfirmed, :confirmed, :canceled].sample }
    price{ 2000 }
    mail_send_flag { [true, false].sample }
  end
end
