namespace :campaign do
  # 1ヶ月のキャンペーンが終わったユーザをクレカ払いに戻す処理
  task :make_oyo_campaign_user_to_normal => :environment do
    limited_users = User.where.not(campaign_id: nil)
                        .where.not(created_at: Time.zone.now - 1.month .. Time.zone.now)
    limited_users.each(&:creditcard!)
  end
end
