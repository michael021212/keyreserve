namespace :reservation do
  desc "Send notice password mail to reserved user."
  task :notice_password_mail => :environment do
    Reservation.ready_to_send.each do |reservation|
      begin
        NotificationMailer.notice_password(reservation).deliver_now
        reservation.update(mail_send_flag: true)
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error "Failed to send notice_password mail. Reservation.id=#{reservation.id}"
        reservation.update(mail_send_flag: true)
      end
    end
  end
end
