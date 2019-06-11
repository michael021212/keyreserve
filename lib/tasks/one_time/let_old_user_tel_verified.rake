namespace :user do
  desc "過去のuserに関しては電話番号認証が済んでいることにする処理"
  task :let_existing_users_sms_verified => :environment do
    User.all.each{ |user| user.update(sms_verified: true) }
  end
end

