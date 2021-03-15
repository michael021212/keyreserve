class Users::UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = User.find user.id
    mail(to: user.email,
         from: 'support@key-stations.com',
         subject: '【KS BOOKING for LiFEREE】パスワード再発行のお知らせ')
  end
end
