#
# admin
#
crumb :admin_root do
  link '管理者トップ', admin_dashboards_path
end

# admin_corporations
crumb :new_admin_corporation do
  link '法人新規登録', new_admin_corporation_path
  parent :admin_corporations
end

crumb :admin_corporation do |corporation|
  link '法人詳細', admin_corporation_path(corporation)
  parent :admin_corporations
end

crumb :edit_admin_corporation do |corporation|
  link '法人編集', admin_corporation_path(corporation)
  parent :admin_corporation, corporation
end

# admin_corporation_users
crumb :admin_corporation_corporation_users do |corporation|
  link '施設管理者一覧', admin_corporation_corporation_users_path
  parent :admin_corporation, corporation
end
crumb :new_admin_corporation_corporation_user do |corporation|
  link '施設管理者新規登録', new_admin_corporation_corporation_user_path
  parent :admin_corporation_corporation_users, corporation
end
crumb :admin_corporation_corporation_user do |corporation, corporation_user|
  link '施設管理者詳細', admin_corporation_corporation_user_path(corporation, corporation_user)
  parent :admin_corporation_corporation_users, corporation
end
crumb :edit_admin_corporation_corporation_user do |corporation, corporation_user|
  link '施設管理者編集', edit_admin_corporation_corporation_user_path(corporation, corporation_user)
  parent :admin_corporation_corporation_user, corporation, corporation_user
end

# admin_personal_identifications
crumb :new_admin_user_personal_identification do |user|
  link '本人確認登録', new_admin_user_personal_identification_path(user)
  parent :admin_user, user
end
crumb :edit_admin_user_personal_identification do |user, personal_identification|
  link '本人確認編集', edit_admin_user_personal_identification_path(user, personal_identification)
  parent :admin_user, user
end

# admin_plans
crumb :admin_corporation_plans do |corporation|
  link 'プラン一覧', admin_corporation_plans_path
  parent :admin_corporation, corporation
end
crumb :new_admin_corporation_plan do |corporation|
  link 'プラン新規登録', new_admin_corporation_plan_path
  parent :admin_corporation_plans, corporation
end
crumb :admin_corporation_plan do |corporation, plan|
  link 'プラン詳細', admin_corporation_plan_path(corporation, plan)
  parent :admin_corporation_plans, corporation
end
crumb :edit_admin_corporation_plan do |corporation, plan|
  link 'プラン編集', edit_admin_corporation_plan_path(corporation, plan)
  parent :admin_corporation_plan, corporation, plan
end

#admin_reservations
crumb :admin_reservations do
  link '会議室予約管理', admin_reservations_path
  parent :admin_root
end
crumb :admin_reservation do |reservation|
  link '会議室予約詳細', admin_reservation_path(reservation)
  parent :admin_reservations
end
crumb :new_admin_reservation do |reservation|
  link '会議室予約新規登録', new_admin_reservation_path
  parent :admin_reservations
end
crumb :payment_admin_reservations do
  link '支払い詳細', payment_admin_reservations_path
  parent :new_admin_reservation
end

#admin_dropin_reservations
crumb :admin_dropin_reservations do
  link 'ドロップイン利用管理', admin_reservations_path
  parent :admin_root
end
crumb :admin_dropin_reservation do |reservation|
  link 'ドロップイン利用詳細', admin_reservation_path(reservation)
  parent :admin_reservations
end

# admin_corporation_user_contracts
crumb :admin_corporation_user_contracts do |corporation|
  link '契約一覧', admin_corporation_user_contracts_path
  parent :admin_corporation, corporation
end
crumb :new_admin_corporation_user_contract do |corporation|
  link '契約新規登録', new_admin_corporation_user_contract_path
  parent :admin_corporation_user_contracts, corporation
end
crumb :admin_corporation_user_contract do |corporation, user_contract|
  link '施設管理者詳細', admin_corporation_user_contract_path(corporation, user_contract)
  parent :admin_corporation_user_contracts, corporation
end
crumb :edit_admin_corporation_user_contract do |corporation, user_contract|
  link '施設管理者編集', edit_admin_corporation_user_contract_path(corporation, user_contract)
  parent :admin_corporation_user_contract, corporation, user_contract
end

# admin_corporation_shops
crumb :new_admin_corporation_shop do |corporation|
  link '店舗新規登録', new_admin_corporation_shop_path
  parent :admin_corporation, corporation
end

crumb :admin_corporation_shop do |corporation, shop|
  link '店舗詳細', admin_corporation_shop_path(corporation, shop)
  parent :admin_corporation, corporation
end

crumb :edit_admin_corporation_shop do |corporation, shop|
  link '店舗編集', edit_admin_corporation_shop_path(corporation, shop)
  parent :admin_corporation_shop, corporation, shop
end

# admin_users
crumb :admin_users do
  link '利用者管理', admin_users_path
  parent :admin_root
end

crumb :new_admin_user do
  link '利用者新規登録', new_admin_user_path
  parent :admin_users
end

crumb :admin_user do |user|
  link '利用者詳細', admin_user_path(user)
  parent :edit_admin_user, user
end

crumb :edit_admin_user do |user|
  link '利用者編集', edit_admin_user_path(user)
  parent :admin_users
end

# admin_user_corp_users
crumb :new_admin_user_corp_user do |user_corp|
  link '利用者新規登録', new_admin_user_corp_user_path(user_corp)
  parent :admin_user_corp, user_corp
end

crumb :admin_user_corp_user do |user_corp, user|
  link '利用者詳細', admin_user_corp_user_path(user_corp, user)
  parent :admin_user_corp, user_corp
end

crumb :edit_admin_user_corp_user do |user_corp, user|
  link '利用者編集', edit_admin_user_corp_user_path(user_corp, user)
  parent :admin_user_corp_user, user_corp, user
end

# admin_user_corps
crumb :admin_user_corps do
  link '法人管理', admin_user_corps_path
  parent :admin_root
end

crumb :new_admin_user_corp do
  link '法人新規登録', new_admin_user_corp_path
  parent :admin_user_corps
end

crumb :admin_user_corp do |user_corp|
  link '法人詳細', admin_user_corp_path(user_corp)
  parent :edit_admin_user_corp, user_corp
end

crumb :edit_admin_user_corp do |user_corp|
  link '法人編集', edit_admin_user_corp_path(user_corp)
  parent :admin_user_corps
end

# admin_corporation_shop_facilities
crumb :new_admin_corporation_shop_facility do |corporation, shop|
  link '施設新規登録', new_admin_corporation_shop_facility_path(corporation, shop)
  parent :admin_corporation_shop, corporation, shop
end

crumb :admin_corporation_shop_facility do |corporation, shop, facility|
  link '施設詳細', admin_corporation_shop_facility_path(corporation, shop, facility)
  parent :admin_corporation_shop, corporation, shop
end

crumb :edit_admin_corporation_shop_facility do |corporation, shop, facility|
  link '施設編集', edit_admin_corporation_shop_facility_path(corporation, shop, facility)
  parent :admin_corporation_shop_facility, corporation, shop, facility
end

# admin_corporation_facility_facility_dropin_plans
crumb :new_admin_corporation_facility_facility_dropin_plans do |corporation, facility|
  link '施設利用ドロップインプラン追加', new_admin_corporation_facility_facility_dropin_plan_path(corporation, facility)
  parent :admin_corporation_shop_facility, corporation, facility.shop, facility
end

crumb :edit_admin_corporation_facility_facility_dropin_plans do |corporation, facility|
  link '施設利用ドロップインプラン編集', edit_admin_corporation_facility_facility_dropin_plan_path(corporation, facility)
  parent :admin_corporation_shop_facility, corporation, facility.shop, facility
end

# admin_corporation_facility_facility_temporary_plans
crumb :new_admin_corporation_facility_facility_temporary_plan do |corporation, facility|
  link '施設利用都度課金プラン追加', new_admin_corporation_facility_facility_temporary_plan_path(corporation, facility)
  parent :admin_corporation_shop_facility, corporation, facility.shop, facility
end

# admin_corporation_shop_facility_facility_keys
crumb :new_admin_corporation_shop_facility_facility_key do |corporation, shop, facility|
  link '施設鍵新規登録', new_admin_corporation_shop_facility_facility_key_path(corporation, shop, facility)
  parent :admin_corporation_shop_facility, corporation, shop, facility
end

crumb :admin_corporation_shop_facility_facility_key do |corporation, shop, facility, facility_key|
  link '施設鍵詳細', admin_corporation_shop_facility_facility_key_path(corporation, shop, facility, facility_key)
  parent :admin_corporation_shop_facility, corporation, shop, facility
end

crumb :edit_admin_corporation_shop_facility_facility_key do |corporation, shop, facility, facility_key|
  link '施設鍵編集', edit_admin_corporation_shop_facility_facility_key_path(corporation, shop, facility, facility_key)
  parent :admin_corporation_shop_facility_facility_key, corporation, shop, facility, facility_key
end

# admin_corporation_facility_facility_temporary_plans
crumb :new_admin_corporation_facility_facility_temporary_plan do |corporation, facility|
  link '施設利用都度課金プラン追加', new_admin_corporation_facility_facility_temporary_plan_path(corporation, facility)
  parent :admin_corporation_shop_facility, corporation, facility.shop, facility
end

crumb :edit_admin_corporation_facility_facility_temporary_plan do |corporation, facility, facility_temporary_plan|
  link '施設利用都度課金プラン編集', edit_admin_corporation_facility_facility_temporary_plan_path(corporation, facility, facility_temporary_plan)
  parent :admin_corporation_shop_facility, corporation, facility.shop, facility
end

# admin_admin_users
crumb :admin_admin_users do
  link '管理者管理', admin_admin_users_path
  parent :admin_root
end

crumb :new_admin_admin_user do
  link '管理者新規登録', new_admin_admin_user_path
  parent :admin_admin_users
end

crumb :edit_admin_admin_user do |admin_user|
  link '管理者編集', admin_admin_user_path(admin_user)
  parent :admin_admin_users
end

# admin_informations
crumb :admin_information_index do
  link 'お知らせ管理', admin_information_index_path
  parent :admin_root
end

crumb :admin_information do |information|
  link 'お知らせ詳細', admin_information_path(information)
  parent :admin_information_index
end

crumb :new_admin_information do
  link 'お知らせ新規登録', new_admin_information_path
  parent :admin_information_index
end

crumb :edit_admin_information do |information|
  link 'お知らせ編集', edit_admin_information_path(information)
  parent :admin_information_index
end

# admin_corporations
crumb :admin_corporations do
  link '法人管理', admin_corporations_path
  parent :admin_root
end

