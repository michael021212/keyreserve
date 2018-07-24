namespace :dropin_reservation do
  desc "Send dropin reservation password mail to user."
  task :dropin_reservation_password_mail => :environment do
    DropinReservation.ready_to_send.each do |dropin_reservation|
      begin
        NotificationMailer.send_dropin_reservation_password(dropin_reservation).deliver_now
        dropin_reservation.update(mail_send_flag: true)
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error "Failed to send dropin reservation password mail. DropinReservation.id=#{dropin_reservation.id}"
        dropin_reservation.update(mail_send_flag: true)
      end
    end
  end
end
