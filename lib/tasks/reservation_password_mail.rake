namespace :reservation do
  desc "Send reservation password mail to user."
  task :reservation_password_mail => :environment do
    rs = Reservation
         .joins(:facility)
         .where.not(facilities: { reservation_type: Facility.reservation_types[:rent_without_ksc] })
         .ready_to_send
    rs_without_ksc = Reservation
                     .joins(:facility)
                     .where(facilities: { reservation_type: Facility.reservation_types[:rent_without_ksc] })
                     .ready_to_send

    # 通常予約のパスワード30分前送付処理
    rs.each do |reservation|
      begin
        NotificationMailer.send_reservation_password(reservation).deliver_now
        reservation.update(mail_send_flag: true)
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error "Failed to send reservation password mail. Reservation.id=#{reservation.id}"
        reservation.update(mail_send_flag: true)
      end
    end

    # 内見(KS Checkin未使用)のパスワード30分前送付処理
    rs_without_ksc.each do |reservation|
      begin
        binding.pry
        NotificationMailer.send_self_viewing_password(reservation).deliver_now
        reservation.update(mail_send_flag: true)
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error "Failed to send reservation password mail. Reservation.id=#{reservation.id}"
        reservation.update(mail_send_flag: true)
      end
    end

  end
end
