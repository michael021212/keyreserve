namespace :reservation do
  desc "Send reservation password mail to user."
  task :reservation_password_mail => :environment do
    Reservation.joins(:facility).where.not(facilities: { facility_type: Facility.facility_types[:rent] }).ready_to_send.each do |reservation|
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
