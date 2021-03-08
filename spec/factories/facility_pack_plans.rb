FactoryBot.define do
  factory :facility_pack_plan do
    facility_id { 1 }
    plan_id { 1 }
    ks_room_key_id { 1 }
    guide_mail_title { "MyString" }
    guide_mail_content { "MyText" }
    guide_file { "MyString" }
    unit_time { "2021-02-15 14:28:46" }
    unit_price { 1 }
    deleted_at { "2021-02-15 14:28:46" }
  end
end
