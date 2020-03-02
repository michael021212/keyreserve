json.result @reservation.persisted?
if @reservation.persisted?
  json.reservation_id @reservation.id
else @reservation.persisted?
  json.error @error
end
