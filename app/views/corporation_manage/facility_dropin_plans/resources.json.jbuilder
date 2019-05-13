json.array! @facility_dropin_plans do |facility_dropin_plan|
  json.id(facility_dropin_plan.id)
  json.title(facility_dropin_plan.decorate.display_plan_name)
end
