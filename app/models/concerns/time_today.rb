module TimeToday
  extend ActiveSupport::Concern
  def time_today(time)
    return if time.nil?
    time.change(year: Time.zone.now.year, month: Time.zone.now.month, day: Time.zone.now.day)
  end
end
