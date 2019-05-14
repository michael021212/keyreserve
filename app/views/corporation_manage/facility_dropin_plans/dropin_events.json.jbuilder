# 時間帯プラン
@facility.facility_dropin_plans.each do |facility_dropin_plan|
  json.array! facility_dropin_plan.facility_dropin_sub_plans do |sp|
    json.resourceId(facility_dropin_plan.id)
    json.title("#{sp.name}\n #{delimiter_price(sp.price)}")
    json.start(current_date(sp.starting_time))
    json.end(current_date(sp.ending_time))
  end
end
