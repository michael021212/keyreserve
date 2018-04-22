set :output, "/path/to/my/cron_log.log"

every 5.minutes do
  rake 'information:informing_mail'
end
