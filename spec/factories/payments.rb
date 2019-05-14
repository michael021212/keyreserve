FactoryBot.define do
  factory :payment do
    user
    corporation
    facility
    credit_card
    price{ 9999 }
    token { SecureRandom.hex(8) }
  end
end
