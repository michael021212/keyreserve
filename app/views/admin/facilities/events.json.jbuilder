json.array! @reservations do |reservation|
  json.title(reservation.user.try(:name))
  json.start(reservation.checkin)
  json.end(reservation.checkout)
end
