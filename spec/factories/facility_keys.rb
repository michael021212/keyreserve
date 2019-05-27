FactoryBot.define do
  factory :facility_key do
    facility
    ks_room_key_id { 1 }
    name { 'テスト鍵' }
  end
end
