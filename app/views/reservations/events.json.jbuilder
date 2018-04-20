json.array! @reservations do |reservation|
  json.title('予約')
  json.start(reservation.checkin)
  json.end(reservation.checkout)
  json.color('#ffb236')
end
