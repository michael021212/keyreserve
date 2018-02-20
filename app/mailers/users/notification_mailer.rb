class Users::NotificationMailer < ApplicationMailer
  default from: 'support@key-reserve.com'

  def user_invitation(email, corporation)
    @corporation = corporation
    mail(to: email, subject: "#{@corporation.name}様からの招待お知らせ")
  end
end
