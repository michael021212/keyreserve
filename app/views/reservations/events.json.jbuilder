json.array! @reservations do |reservation|
  json.title('予約')
  json.start(reservation.checkin)
  json.end(reservation.checkout)
  json.color('#ffb236')
  json.reservation("時間: #{time_fmt(reservation.checkin)}-#{time_fmt(reservation.checkout)}")
end
