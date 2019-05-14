json.array! @reservations do |reservation|
  json.title(reservation.decorate.display_user_name)
  json.start(reservation.checkin)
  json.end(reservation.checkout)
  json.color('#ff3636') if reservation.block_flag?
end
