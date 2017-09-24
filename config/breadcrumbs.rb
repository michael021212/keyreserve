#
# admin
#
crumb :admin_root do
  link '管理者トップ', admin_dashboards_path
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

crumb :admin_admin_user do |admin_user|
  link '管理者詳細', admin_admin_user_path(admin_user)
  parent :admin_admin_users
end

crumb :edit_admin_admin_user do |admin_user|
  link '管理者編集', admin_admin_user_path(admin_user)
  parent :admin_admin_user, admin_user
end

# admin_corporations
crumb :admin_corporations do
  link '法人管理', admin_corporations_path
  parent :admin_root
end

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
crumb :new_admin_corporation_user do |corporation|
  link 'ユーザ新規登録', new_admin_corporation_user_path(corporation)
  parent :admin_corporation, corporation
end

crumb :admin_corporation_user do |corporation, user|
  link 'ユーザ詳細', admin_corporation_user_path(corporation, user)
  parent :admin_corporation, corporation
end

crumb :edit_admin_corporation_user do |corporation, user|
  link 'ユーザ編集', admin_corporation_user_path(corporation, user)
  parent :admin_corporation, corporation
end
