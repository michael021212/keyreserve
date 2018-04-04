json.array! @plans do |plan|
  json.id(plan.id.to_s)
  json.title(plan.name)
end
