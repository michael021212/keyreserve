FactoryBot.define do
  factory :reservation do
    facility
    user
    payment
    checkin { Time.zone.now - 2.days }
    checkout { Time.zone.now - 1.days }
    usage_period { [*1..10].sample }
    num { [*1..5].sample }
    state { [:unconfirmed, :confirmed, :canceled].sample }
    block_flag { true }
    price{ 2000 }
    mail_send_flag { [true, false].sample }
    reservation_user_id { nil }
  end
end
