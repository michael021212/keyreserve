FactoryBot.define do
  factory :credit_card do
    user
    card_no { "1234" }
    sequence 1
    kind { [:visa, :master].sample }
    sequence(:name) { |n| "TEST TARO#{n}" }

    trait 'with_stripe' do
      stripe_card_id { "card_#{SecureRandom.hex(8)}" }
    end
  end
end
