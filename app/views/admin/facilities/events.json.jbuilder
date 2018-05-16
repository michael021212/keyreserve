json.array! @reservations do |reservation|
  json.title(reservation.block_flag? ? 'ブロック' : reservation.user.try(:name))
  json.start(reservation.checkin)
  json.end(reservation.checkout)
  json.color('#ff3636') if reservation.block_flag?
end
