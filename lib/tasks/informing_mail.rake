namespace :information do
  desc "Send informing mail to users"
  task :informing_mail => :environment do
    Information.ready_to_send.each do |information|
      if information.important_notice?
        User.all.each do |user|
          UserMailer.event_informing_mail(information, user).deliver_now
        end
      elsif information.shop.present? && information.event?
        User.has_contract_with_shop(information.shop_id).each do |user|
          next unless user.advertise_notice_flag?
          UserMailer.event_informing_mail(information, user).deliver_now
        end
      else
        # 全体のイベントや告知
        User.all.each do |user|
          next unless user.advertise_notice_flag?
          UserMailer.event_informing_mail(information, user).deliver_now
        end
      end
      information.update(mail_send_flag: true)
    end
  end
end
