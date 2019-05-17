FactoryBot.define do
  factory :corporate_admin_user do
    sequence(:email) { |n| "corporate_admin_user#{n}@example.com" }
    sequence(:name) { |n| "施設管理者#{n}" }
    password { 'password' }
    tel { "09012345678" }
    state { :registered }
    payway { :invoice }
    user_type { :corporate_admin }
    advertise_notice_flag { false }
  end
end
