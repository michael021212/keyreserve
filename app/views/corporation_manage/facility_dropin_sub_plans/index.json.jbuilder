json.array! @facility_dropin_sub_plans do |sub_plan|
  json.resourceId(sub_plan.facility_dropin_plan_id)
  json.title("#{sub_plan.name}\n #{delimiter_price(sub_plan.price)}")
  json.start(current_date(sub_plan.starting_time))
  json.end(current_date(sub_plan.ending_time))
end
