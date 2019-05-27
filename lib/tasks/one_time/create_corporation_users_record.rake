namespace :user do
  desc "corporation_usersテーブルに、過去ユーザと企業のひも付きレコードの作成"
  task :create_corporation_users_record => :environment do
    User.all.each{ |user| user.corporation_users.create(corporation_id: Corporation.find_by(name: 'KEY STATION').id) }
  end
end


