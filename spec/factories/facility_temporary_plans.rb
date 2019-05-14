FactoryBot.define do
  factory :facility_temporary_plan do
    facility
    plan
    ks_room_key_id { 1 }
    guide_mail_title { 'テストメール' }
    guide_mail_content { 'テストメールだよー！' }
    standard_price_per_hour { 10000 }
    standard_price_per_day { 5000 }
  end
end
