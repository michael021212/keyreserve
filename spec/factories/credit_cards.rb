FactoryBot.define do
  factory :credit_card do
    user
    card_no { "1234" }
    kind { [:visa, :master].sample }
    number { '123123123' }
    exp { '12 / 23' }
    cvc { '929' }
    holder_name { 'YAMADA TARO' }
    stripe_card_id { "card_#{SecureRandom.hex(8)}" }
  end
end
