if @reservation.blank?
  json.result false
  json.error 'reservation is not found'
elsif !@reservation.block_flag
  json.result false
  json.error 'reservation is invalid'
else
  json.result true
end
