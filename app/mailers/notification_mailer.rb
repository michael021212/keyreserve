class NotificationMailer < ApplicationMailer
  def new_user_contract(cu, user_contract)
    @user_contract = user_contract
    @user = user_contract.user
    @shop = user_contract.shop
    @plan = user_contract.plan
    mail(to: cu.email, subject: "【KS Booking】#{@user.name}からの申し込みが来ました")
  end

  def user_invitation(email, user)
    @user = user
    mail(to: email, subject: "【#{Settings.sitename}】#{user.name}様からのご招待")
  end

  def campaign_user_registration(user)
    @user = user
    mail(to: @user.email, subject: "【KS Booking】ご登録ありがとうございます")
  end

  def campaign_user_registration_to_admin(user)
    @user = user
    mail(to: 'contact@keeyls.com', subject: "【KS Booking】新しいユーザが登録されました")
  end

  def campaign_finished(user)
    @user = user
    mail(to: user.email, subject: "【KS Booking】キャンペーン期間が終了致しました")
  end

  def campaign_finished_to_admin(user)
    @user = user
    mail(to: 'contact@keeyls.com', subject: "【KS Booking】キャンペーン期間が終了したユーザがいます")
  end

  def postal_matter_notification(user)
    @user = user
    mail(to: @user.email, cc: 'contact@keeyls.com', subject: "【KEY STAION OFFICE・WORK＆STAY BAMPKY】郵便物について")
  end

  def reserved(reservation, user_id, ksc_reservation_no=nil, ks_room_key_info=nil)
    user = User.find(user_id)
    return if user.email.blank?
    @reservation = reservation
    @ksc_reservation_no = ksc_reservation_no
    @ks_room_key_info = ks_room_key_info
    mail(to: user.email, subject: "【KS Booking】施設のご予約を承りました")
  end

  def reserved_to_corporation(reservation)
    @reservation = reservation
    mail(to: reservation.facility.shop.corporation.email, subject: "【KS Booking】施設の予約が入りました")
  end

  def reserved_to_admin(reservation)
    @reservation = reservation
    mail(to: 'contact@keeyls.com', subject: "【KS Booking】施設の予約が入りました")
  end

  def dropin_reserved(dropin_reservation, user_id)
    user = User.find(user_id)
    return if user.email.blank?
    @dropin_reservation = dropin_reservation
    mail(to: user.email, subject: "【KS Booking】施設のご予約を承りました")
  end

  def dropin_reserved_to_admin(dropin_reservation)
    @dropin_reservation = dropin_reservation
    mail(to: 'contact@keeyls.com', subject: "【KS Booking】ドロップインの予約が入りました")
  end

  # 施設利用予約がキャンセルされた際のメール
  def reservation_canceled(reservation, user_id)
    user = User.find(user_id)
    return if user.email.blank?
    @reservation = reservation
    mail(to: user.email, subject: "【KS Booking】施設のご予約をキャンセル致しました")
  end

  # 施設利用予約がキャンセルされた際のAdmin宛メール
  def reservation_canceled_to_admin(reservation)
    @reservation = reservation
    mail(to: 'contact@keeyls.com', subject: "【KS Booking】施設の予約がキャンセルされました")
  end

  # 施設利用予約がキャンセルされた際の企業宛メール
  def reservation_canceled_to_corporation(reservation)
    @reservation = reservation
    mail(to: reservation.facility.shop.corporation.email, subject: "【KS Booking】施設の予約がキャンセルされました")
  end

  # ドロップイン予約がキャンセルされた際のメール
  def dropin_reservation_canceled(dropin_reservation, user_id)
    user = User.find(user_id)
    return if user.email.blank?
    @dropin_reservation = dropin_reservation
    mail(to: user.email, subject: "【KS Booking】ドロップインのご予約をキャンセル致しました")
  end

  # ドロップイン予約がキャンセルされた際の管理者宛メール
  def dropin_reservation_canceled_to_admin(dropin_reservation)
    @dropin_reservation = dropin_reservation
    mail(to: 'contact@keeyls.com', subject: "【KS Booking】ドロップインの予約がキャンセルされました")
  end

  def send_reservation_password(reservation)
    plan_ids = reservation.user.user_contracts.pluck(:plan_id).presence
    ftps = reservation.facility.facility_temporary_plans.where(plan_id: plan_ids)
    ftps = reservation.facility.facility_temporary_plans.where(plan_id: nil) if ftps.blank?
    @ftp = reservation.facility.accommodation? ? ftps.min_by(&:standard_price_per_day) : ftps.min_by(&:standard_price_per_hour)
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

  def send_dropin_reservation_password(dropin_reservation)
    @dropin_reservation = dropin_reservation
    @password = KeystationService.sync_room_key_password(@dropin_reservation.facility_key.ks_room_key_id)
    @fdp = @dropin_reservation.facility_dropin_plan
    attachments[@fdp.guide_file.file.filename] = @fdp.guide_file.read if @fdp.guide_file.present?
    return if @fdp.guide_mail_title.blank?
    if @dropin_reservation.send_cc_mail?
      mail(to: @dropin_reservation.reservation_user.email, cc: @dropin_reservation.user.email, subject: @fdp.guide_mail_title)
    else
      mail(to: @dropin_reservation.reservation_user.email, subject: @fdp.guide_mail_title)
    end
  end

  def upload_identification(personal_identification)
    @personal_identification = personal_identification
    mail(to: 'contact@keeyls.com', subject: "【KS Booking】本人確認の資料がアップされました")
  end

  def verification_confirmed(personal_identification)
    @personal_identification = personal_identification
    mail(to: personal_identification.user.email, subject: "【KS Booking】本人確認の申請は認証されました")
  end
end
