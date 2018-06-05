(@start.to_date..@end.to_date).each do |date|
  @facility.available_reservation_area(date.to_s(:date)).each do |time|
    period_price = FacilityTemporaryPlan.unit_price(@user, @facility, Time.zone.parse(time[0]), Time.zone.parse(time[1]))
    json.array! period_price do |a|
      json.start(a[0])
      json.end(a[1])
      json.title("#{a[2]}円/１時間")
      json.color('#c6e2b3')
      json.textColor('#507f30')
    end
  end
end
