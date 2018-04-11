json.array! @facility_temporary_plans do |facility_temporary_plan|
  json.id(facility_temporary_plan.id)
  json.title(facility_temporary_plan.plan_name.present? ? facility_temporary_plan.plan_name : '契約なしで使用される場合')
end
