(@start.to_date..@end.to_date).each do |date|
  @facility.available_reservation_area(date.to_s(:date)).each do |opening_and_closing_times|
    parced_opening_and_closing_times = []
    parced_opening_and_closing_times << Time.zone.parse(opening_and_closing_times[0])
    parced_opening_and_closing_times << Time.zone.parse(opening_and_closing_times[1])

    json.array! (parced_opening_and_closing_times[0].to_i .. parced_opening_and_closing_times[1].to_i).step(30.minutes) do |t|
      next if parced_opening_and_closing_times[1].to_i == t
      json.start(Time.at(t))
      json.end(Time.at(t) + 30.minutes)
      json.color('#c6e2b3')
      json.textColor('#507f30')
    end
  end
end
