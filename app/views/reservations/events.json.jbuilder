json.array! @reservations do |reservation|
  json.title('δΊη΄')
  json.start(reservation.checkin)
  json.end(reservation.checkout)
  json.color('#ffb236')
  json.reservation("ζι: #{time_fmt(reservation.checkin)}-#{time_fmt(reservation.checkout)}")
end
