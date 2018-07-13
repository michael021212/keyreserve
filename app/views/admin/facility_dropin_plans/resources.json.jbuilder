json.array! @facility_dropin_plans do |facility_dropin_plan|
  json.id(facility_dropin_plan.id)
  json.title(facility_dropin_plan.plan.try(:name).present? ? facility_dropin_plan.plan.name : '非会員')
end
