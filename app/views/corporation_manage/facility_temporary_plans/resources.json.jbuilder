json.array! @facility_temporary_plans do |facility_temporary_plan|
  json.id(facility_temporary_plan.id)
  json.title(facility_temporary_plan.plan_name.present? ? facility_temporary_plan.plan_name : '非会員')
end
