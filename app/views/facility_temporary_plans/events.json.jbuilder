json.array! @facility_temporary_plans.each do |facility_temporary_plan|
  json.resourceId(facility_temporary_plan.id.to_s)
  json.title("#{delimiter_price(facility_temporary_plan.standard_price_per_day)}/h")
  json.start(Time.zone.now.beginning_of_day)
  json.allDay(true)
  json.color('#aaa')
end
@facility_temporary_plans.each do |facility_temporary_plan|
  json.array! facility_temporary_plan.facility_temporary_plan_prices do |pp|
    json.resourceId(facility_temporary_plan.id.to_s)
    json.title("#{delimiter_price(pp.price)}/h")
    json.start(current_date(pp.starting_time))
    json.end(current_date(pp.ending_time))
    json.color('orange')
  end
  json.array! facility_temporary_plan.standard_price_per_hour_area do |pp|
    json.resourceId(facility_temporary_plan.id.to_s)
    json.title("#{delimiter_price(facility_temporary_plan.standard_price_per_hour)}/h")
    json.start(current_date(pp[0]))
    json.end(current_date(pp[1]))
    json.color('#aaa')
  end
end
