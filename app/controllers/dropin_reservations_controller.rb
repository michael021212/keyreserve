class DropinReservationsController <  ApplicationController
  before_action :set_user
  before_action :require_login, except: [:dropin_spot]
  before_action :require_sms_verification, except: [:dropin_spot]
  include ActionView::Helpers::NumberHelper

  def index
    @dropin_reservations = @user.dropin_reservations.order(checkin: :desc).page(params[:page])
  end

  def show
    @dropin_reservation = @user.dropin_reservations.find(params[:id])
  end

  def dropin_spot
    params[:dropin_spot] ||= {}
    params[:dropin_spot][:checkin_time] ||= '12:00'
    cond = params[:dropin_spot]
    if cond.blank? || cond[:checkin].blank? || cond[:checkin_time].blank? || cond[:use_hour].blank?
      return render :dropin_spot
    end

    checkin = Time.zone.parse(cond[:checkin] + " " + cond[:checkin_time])
    checkout = checkin + cond[:use_hour].to_i.hours

    unless checkin.strftime('%Y/%m/%d') == checkout.strftime('%Y/%m/%d')
      return render :dropin_spot
    end

    if Date.parse(cond[:checkin]) < Time.zone.today
      flash[:error] = 'ご予約は本日以降となります'
      return render :dropin_spot
    end
    sub_plan_ids = FacilityDropinSubPlan.available_ids(checkin, checkout)
    @facilities = Facility.logout_dropin_spots
    @facilities = @facilities.where(id: @user.member_facility_dropin_sub_plan).has_facility_dropin_sub_plans(sub_plan_ids) if @user.present?
    @facilities = @facilities.page(params[:page])
    session[:dropin_spot] = cond
  end

  def new
    params[:dropin_spot] ||= session[:dropin_spot]
    f_id = params.dig(:dropin_spot, :facility_id).present? ? params[:dropin_spot]['facility_id'] : params[:facility_id]
    @facility = @user.login_dropin_spots.find(f_id)
    @facility_dropin_sub_plan = Facility.recommended_sub_plan(params[:facility_id], params[:dropin_spot], @user)
    cond = params[:dropin_spot]
  end

  def confirm
    session[:dropin_spot] = params[:dropin_spot] if params[:dropin_spot].present?
    @facility = Facility.find(session[:dropin_spot]['facility_id'])
    unless current_user.personal_identification.try(:confirmed?)
      flash[:error] = "こちらの施設は本人確認済みの利用者のみご利用できます。本人確認の登録は#{view_context.link_to('こちら', user_path,  {style: 'color: #ebc243;'})}です".html_safe
      return render :new
    end

    if session[:dropin_spot]['sub_plan'].blank?
      flash[:error] = 'ご利用プランを入力してください'
      return render :new
    end

    @sub_plan = FacilityDropinSubPlan.find(session[:dropin_spot]['sub_plan'])
    y, m, d = session[:dropin_spot]['checkin'].split('/')
    @checkin = @sub_plan.starting_time.change(year: y, month: m, day: d)
    @checkout = @sub_plan.ending_time.change(year: y, month: m, day: d)

    if @checkin < Time.zone.today
      flash[:error] = 'ご予約は本日以降となります'
      return render :new
    end

    if @user.credit_card.blank? && @user.creditcard?
      @credit_card = @user.build_credit_card
      return render :credit_card
    end

    reserved_key_num = @facility.dropin_reservations.in_range(@checkin..@checkout).count
    total_key_num = @facility.facility_keys.count
    if reserved_key_num >= total_key_num
      flash[:error] = 'この時間帯のご予約はできません'
      return render :new
    end
  end

  def plan
    cond = params[:dropin_spot]
    if cond.blank? || cond[:sub_plan].blank?
      return render json: { price: '', time: '' }
    end
    sub_plan = FacilityDropinSubPlan.find(cond[:sub_plan])
    render json: { price: number_with_delimiter(sub_plan.price), time: sub_plan.using_period }
  end

  def credit_card
    @facility = Facility.find(session[:dropin_spot]['facility_id'])
    return redirect_to confirm_dropin_reservations_path if @user.credit_card.present?
    @credit_card = @user.build_credit_card(credit_card_params)
    return(render :credit_card) unless @credit_card.valid?
    begin
      @credit_card.save!
      @user.activated!
      redirect_to confirm_dropin_reservations_path
    rescue => e
      logger.warn("#{e.class.name} #{e.message}")
      flash[:alert] = 'クレジットカードの登録に失敗しました'
      render :credit_card
    end
  end

  def create
    @dropin_reservation = DropinReservation.new_from_dropin_spot(session[:dropin_spot], @user, current_user)
    @dropin_reservation.set_payment
    ActiveRecord::Base.transaction do
      @dropin_reservation.save!
      @dropin_reservation.payment.stripe_charge!
      session[:dropin_spot] = nil
      session[:reservation_id] = @dropin_reservation.id
      @dropin_reservation.send_dropin_reserved_mails
      if @dropin_reservation.checkin < Time.zone.now
        NotificationMailer.send_dropin_reservation_password(@dropin_reservation).deliver_now
        @dropin_reservation.update!(mail_send_flag: true)
      end
    end
    redirect_to thanks_dropin_reservations_path
  rescue
    flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
    redirect_to dropin_spot_dropin_reservations_path
  end

  def thanks
    @dropin_reservation = DropinReservation.find(session[:reservation_id])
    @facility = @dropin_reservation.facility
  end

  def destroy
    @dropin_reservation = DropinReservation.find(params[:id])
    ActiveRecord::Base.transaction do
      @dropin_reservation.destroy!
      NotificationMailer.dropin_reservation_canceled(@dropin_reservation, @dropin_reservation.user_id).deliver_now if @dropin_reservation.send_cc_mail?
      NotificationMailer.dropin_reservation_canceled(@dropin_reservation, @dropin_reservation.reservation_user_id).deliver_now
      NotificationMailer.dropin_reservation_canceled_to_admin(@dropin_reservation).deliver_now
    end
    redirect_to dropin_reservations_path, notice: '予約をキャンセルしました'
  rescue => e
    logger.debug(e)
    redirect_to dropin_reservations_path, alert: '処理中にエラーが発生しました。'
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def credit_card_params
    params.require(:credit_card).permit(
      :number, :exp, :holder_name, :cvc
    )
  end
end
