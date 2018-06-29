(@start.to_date..@end.to_date).each do |date|
  @facility.available_reservation_area(date.to_s(:date)).each do |time|
    period_price = FacilityTemporaryPlan.unit_price(@user, @facility, Time.zone.parse(time[0]), Time.zone.parse(time[1]))
    period_price.each do |a|
      json.array! (a[0].to_i .. a[1].to_i).step(30.minutes) do |t|
        next if a[1].to_i == t
        json.start(Time.at(t))
        json.end(Time.at(t) + 30.minutes)
        json.title("#{a[2]}円/１h") if a[0].to_i == t
        json.color('#c6e2b3')
        json.textColor('#507f30')
      end
    end
  end
end
