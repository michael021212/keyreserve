namespace :facility do
  desc 'reservation_typeがgeneral(1)とrent_without_ksc(11)のもの=>rent_without_ksc(0)に統一、rent_with_ksc(10)のもの=>rent_with_ksc(1)にする'
  task change_reservation_type: :environment do
    Facility.where(reservation_type: [1, 11]).each { |facility| facility.update_attribute(:reservation_type, 0) }
    Facility.where(reservation_type: 10).each { |facility| facility.update_attribute(:reservation_type, 1) }
  end
end
