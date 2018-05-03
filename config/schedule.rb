require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every 5.minutes do
  rake 'information:informing_mail'
end

every 5.minutes do
  rake 'reservation:notice_password_mail'
end
