FactoryBot.define do
  factory :user_corp do
    sequence(:email) { |n| "houzin#{n}@example.com" }
    sequence(:name) { |n| "法人#{n}" }
    password { 'password' }
    tel { "09012345678" }
    max_user_num { 10 }
    state { :registered }
    payway { :invoice }
    user_type { :parent_corporation }
    advertise_notice_flag { false }
  end
end
