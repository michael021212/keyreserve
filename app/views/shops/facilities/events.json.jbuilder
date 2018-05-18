json.array! @reservations do |reservation|
  json.start(reservation.checkin)
  json.end(reservation.checkout)
  json.color('#ff3636')
end
@start.upto(@end).each do |date|
  json.array! @facility.available_reservation_area(date) do |a|
    json.start(a[0])
    json.end(a[1])
  end
end
