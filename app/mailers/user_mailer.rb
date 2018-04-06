class UserMailer < ApplicationMailer
  def event_informing_mail(information, user)
    @information = information
    @user = user
    mail(to: @user.email ,subject: "#{@information.title} - #{(@information.shop_name || 'KEY STATION OFFICE運営')}")
  end
end
