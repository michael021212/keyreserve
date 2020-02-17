json.result @user.persisted?
if @user.persisted?
  json.user_id @user.id
else
  json.errors @e.message
end
