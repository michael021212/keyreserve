namespace :reservation do
  desc "Send reservation password mail to user."
  task :reservation_password_mail => :environment do
    reservations = Reservation
                  .joins(:facility)
                  .where(facilities: { reservation_type: [Facility.reservation_types[:general], Facility.reservation_types[:rent_without_ksc]]})
                  .ready_to_send
    reservations.each do |reservation|
      begin
        NotificationMailer.send_reservation_password(reservation).deliver_now
        reservation.update(mail_send_flag: true)
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error "Failed to send reservation password mail. Reservation.id=#{reservation.id}"
        reservation.update(mail_send_flag: true)
      end
    end
  end
end
