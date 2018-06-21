class NotificationMailer < ApplicationMailer
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

  def reserved(reservation, user_id)
    user = User.find(user_id)
    return if user.email.blank?
    @reservation = reservation
    mail(to: user.email, subject: "【KeyStation Office】施設のご予約を承りました")
  end

  def reserved_to_admin(reservation)
    @reservation = reservation
    mail(to: 'contact@key-stations.jp', subject: "【KeyStation Office】会議室の予約が入りました")
  end

  def dropin_reserved(dropin_reservation, user_id)
    user = User.find(user_id)
    return if user.email.blank?
    @dropin_reservation = dropin_reservation
    mail(to: user.email, subject: "【KeyStation Office】施設のご予約を承りました")
  end

  def dropin_reserved_to_admin(dropin_reservation)
    @dropin_reservation = dropin_reservation
    mail(to: 'contact@key-stations.jp', subject: "【KeyStation Office】ドロップインの予約が入りました")
  end

  def notice_password(reservation)
    @reservation = reservation
    plan_ids = @reservation.user.user_contracts.pluck(:plan_id)
    @member_ftps = reservation.facility.facility_temporary_plans.where(plan_id: plan_ids)
    @not_member_ftp = reservation.facility.facility_temporary_plans.where.not(standard_price_per_hour: 0).where(plan_id: nil)
    @ftp = @member_ftps.present? ? @member_ftps.first : @not_member_ftp.first
    @ftp_title = @ftp.guide_mail_title
    @password = KeystationService.sync_room_key_password(@ftp.ks_room_key_id)
    attachments[@ftp.guide_file.file.filename] = @ftp.guide_file.read if @ftp.guide_file.present?
    return if @ftp.guide_mail_title.blank?
    if reservation.send_cc_mail?
      mail(to: reservation.reservation_user.email, cc: reservation.user.email, subject: @ftp_title)
    else
      mail(to: reservation.reservation_user.email, subject: @ftp_title)
    end
  end

  def verification_confirmed(personal_identification)
    @personal_identification = personal_identification
    mail(to: personal_identification.user.email, subject: "【KeyStation Office】本人確認の申請は認証されました")
  end
end
