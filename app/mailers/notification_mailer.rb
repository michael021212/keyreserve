class NotificationMailer < ApplicationMailer
  default from: 'support@key-reserve.com'

  def new_user_contract(cu, user_contract)
    @user_contract = user_contract
    @user = user_contract.user
    @shop = user_contract.shop
    @plan = user_contract.plan
    mail(to: cu.email, subject: "【KeyStation Office】#{@user.name}からの申し込みが来ました")
  end

  def user_invitation(email, user)
    @user = user
    mail(to: email, subject: "【#{Settings.sitename}】#{user.name}様からのご招待")
  end

  def reserved(reservation)
    @reservation = reservation
    mail(to: reservation.user.email, subject: "【KeyStation Office】施設のご予約を承りました")
  end
end
