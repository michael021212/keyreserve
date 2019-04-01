namespace :campaign do
  # 1ヶ月のキャンペーンが終わったユーザをクレカ払いに戻す処理
  task :make_oyo_campaign_user_to_normal => :environment do
    limited_users = User
                    .invoice
                    .where.not(campaign_id: nil)
                    .where.not(created_at: Time.zone.now - 1.month .. Time.zone.now)
    limited_users.each do |user|
      user.creditcard!
      NotificationMailer.campaign_finished(user).deliver_now
      NotificationMailer.campaign_finished_to_admin(user).deliver_now
    end
  end
end
