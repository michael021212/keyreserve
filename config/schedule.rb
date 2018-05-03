every 5.minutes do
  rake 'information:informing_mail'
end

every 5.minutes do
  rake 'reservation:notice_password_mail'
end
