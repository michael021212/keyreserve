# 標準価格（1日課金）
json.array! @facility_temporary_plans.each do |facility_temporary_plan|
  json.resourceId(facility_temporary_plan.id.to_s)
  json.title("#{delimiter_price(facility_temporary_plan.standard_price_per_day)}")
  json.start(Time.zone.now.beginning_of_day)
  json.allDay(true)
end
@facility_temporary_plans.each do |facility_temporary_plan|
  # 施設利用都度課金プラン時間帯価格
  json.array! facility_temporary_plan.facility_temporary_plan_prices do |pp|
    json.resourceId(facility_temporary_plan.id.to_s)
    json.title("#{delimiter_price(pp.price)}/h")
    json.start(current_date(pp.starting_time))
    json.end(current_date(pp.ending_time))
    json.color('orange')
  end
  # 標準価格（時間課金）
  json.array! facility_temporary_plan.standard_price_per_hour_area do |pp|
    json.resourceId(facility_temporary_plan.id.to_s)
    json.title("#{delimiter_price(facility_temporary_plan.standard_price_per_hour)}/h")
    json.start(current_date(pp[0]))
    json.end(current_date(pp[1]))
  end
end
