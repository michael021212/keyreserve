FactoryBot.define do
  factory :user_contract do
    corporation
    shop
    user
    plan
    started_on { Time.zone.now - 3.days}
    finished_on { Time.zone.now + 1.days }
    state { :applying }
  end
end
