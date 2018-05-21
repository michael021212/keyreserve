json.array! @reservations do |reservation|
  json.start(reservation.checkin)
  json.end(reservation.checkout)
  json.color('#ff3636')
end

(@start.to_date..@end.to_date).each do |date|
  date = date.strftime('%Y-%m-%d')
  @facility.available_reservation_area(date).each do |time|
    period_price = FacilityTemporaryPlan.unit_price_for_user(current_user, @facility, Time.zone.parse(time[0]), Time.zone.parse(time[1]))
    json.array! period_price do |a|
      json.start(a[0])
      json.end(a[1])
      json.title("#{a[2]}円/１時間")
    end
  end
end
