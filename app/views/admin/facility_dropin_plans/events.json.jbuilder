# 一時間単位
json.array! @facility_dropin_plans.each do |facility_dropin_plan|
  json.resourceId(facility_dropin_plan.id.to_s)
  json.title("#{delimiter_price(facility_dropin_plan.usage_fee_per_hour)}")
  json.start(Time.zone.now.beginning_of_day)
  json.allDay(true)
end

# 時間帯プラン
@facility.facility_dropin_plans.each do |facility_dropin_plan|
  json.array! facility_dropin_plan.facility_dropin_sub_plans do |sp|
    json.resourceId(facility_dropin_plan.id.to_s)
    json.title("#{sp.name}\n #{delimiter_price(sp.price)}")
    json.start(current_date(sp.starting_time))
    json.end(current_date(sp.ending_time))
  end
end
