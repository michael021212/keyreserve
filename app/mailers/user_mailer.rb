class UserMailer < ApplicationMailer
  def event_informing_mail(information, user)
    @information = information
    @user = user
    mail(to: @user.email ,subject: "【#{@information.info_type_i18n}】 #{@information.title}")
  end
end
