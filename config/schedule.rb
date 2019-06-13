require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every 5.minutes do
  rake 'information:informing_mail'
end

every 5.minutes do
  rake 'reservation:reservation_password_mail'
end

every 5.minutes do
  rake 'dropin_reservation:dropin_reservation_password_mail'
end

every 1.month, at: 'start of the month at 1am' do
  rake 'billing:create_monthly_billings'
end

# every 1.day, at: '9:00 am' do
#   rake 'campaign:make_oyo_campaign_user_to_normal'
# end
