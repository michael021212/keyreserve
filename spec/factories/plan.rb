FactoryBot.define do
  factory :plan do
    corporation
    sequence(:name) { |n| "プラン#{n}"}
    price { 0 }
    default_flag { false }
    description { 'テストプランです' }
  end
end

