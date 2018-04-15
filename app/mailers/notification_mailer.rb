class NotificationMailer < ApplicationMailer
  def user_invitation(email, user)
    @user = user
    mail(to: email, subject: "【#{Settings.sitename}】#{user.name}様からのご招待")
  end
end
