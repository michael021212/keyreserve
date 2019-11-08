json.set! :facility do
  json.id @facility.id
  json.name @facility.name
  json.set! :facility_key do
    json.id @facility_key.id
    json.ks_room_key_id @facility_key.ks_room_key_id
  end
end
