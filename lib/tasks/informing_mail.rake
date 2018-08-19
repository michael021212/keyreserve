namespace :information do
  desc "Send informing mail to users"
  task :informing_mail => :environment do
    Information.ready_to_send.each do |information|
      users = []
      if information.all_users?
        users = User.all
      else
        users = User.has_contract_with_shops(information.shops.pluck(:id))
      end
      users.each do |user|
        next if information.event? && !user.advertise_notice_flag?
        if user.personal?
          UserMailer.event_informing_mail(information, user).deliver_now
        elsif user.parent_corporation?
          user.belongs_users.each do |u|
            next if information.event? && !u.advertise_notice_flag?
            UserMailer.event_informing_mail(information, u).deliver_now
          end
        end
      end
      information.update(mail_send_flag: true)
    end
  end
end
