FactoryBot.define do
  factory :information do
    shop
    sequence(:title) { |n| "タイトル#{n}"}
    sequence(:description) { |n| "説明文#{n}"}
    info_type { [:event, :important_notice].sample }
    published_at { Time.zone.now }
    mail_send_flag { false }
    info_target_type { [:all_users, :shop_users].sample }

    trait :event do
      info_type { :event }
    end
    trait :important_notice do
      info_type { :important_notice }
    end

    trait :for_all_users do
      info_target_type { :all_users }
    end
    trait :for_shop_users do
      info_target_type { :for_shop_users }
    end
  end
end
