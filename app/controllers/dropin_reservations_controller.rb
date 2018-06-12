class DropinReservationsController <  ApplicationController
  before_action :set_user
  before_action :require_login, except: [:dropin_spot]
  include ActionView::Helpers::NumberHelper

  def dropin_spot
    params[:dropin_spot] ||= {}
    params[:dropin_spot][:checkin_time] ||= '12:00'
    cond = params[:dropin_spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank?
      return render :dropin_spot
    end

    if cond[:checkin] < Time.zone.now - 30.minutes
      flash[:error] = 'ご予約はご利用の30分前までとなります'
      return render :dropin_spot
    end

    @facilities = logged_in? ? @user.login_dropin_spots : Facility.logout_dropin_spots
    @facilities = @facilities.page(params[:page])
    session[:dropin_spot] = cond
  end

  def new
    params[:dropin_spot] ||= session[:dropin_spot]
    session[:reservation_id] = nil
    @facility = @user.login_dropin_spots.find(params[:facility_id])

    # Facility.recommended_facility_dropin_sub_plan(@facility, @user, params[:dropin_spot][:checkin_time], params[:dropin_spot][:use_hour])
  end

  def confirm
    session[:dropin_spot] = params[:dropin_spot] if params[:dropin_spot].present?
    @facility = Facility.find(session[:dropin_spot]['facility_id'].to_i)
    @sub_plan = FacilityDropinSubPlan.find(session[:dropin_spot]['sub_plan'].to_i)
    y, m, d = session[:dropin_spot]['checkin'].split('/')
    @checkin = @sub_plan.starting_time.change(year: y, month: m, day: d)
    @checkout = @sub_plan.ending_time.change(year: y, month: m, day: d)
    if @checkin < Time.zone.now - 30.minutes
      flash[:error] = 'ご予約はご利用の30分前までとなります'
      return render :new
    end
    if @checkin.to_s(:time) < @facility.shop.opening_time.to_s(:time) ||
        @checkout.to_s(:time) > @facility.shop.closing_time.to_time.to_s(:time)
      flash[:error] = 'ご予約時間が営業時間外となります'
      return render :new
    end

    if @user.credit_card.blank? && @user.creditcard?
       @credit_card = @user.build_credit_card
      return render :credit_card
    end
  end

  def price
    @facility = @user.login_dropin_spots.find(params[:facility_id]) if params[:facility_id].present?
    cond = params[:dropin_spot]
    if cond.blank? || cond[:sub_plan].blank?
      return render json: {price: ''}
    end
    sub_plan = FacilityDropinSubPlan.find(cond[:sub_plan].to_i)
    render json: {price: number_with_delimiter(sub_plan.price)}
  end

  def credit_card
    @facility = Facility.find(session[:dropin_spot]['facility_id'].to_i)
    return redirect_to confirm_dropin_reservations_path if @user.credit_card.present?
    @credit_card = @user.build_credit_card(credit_card_params)
    return(render :credit_card) unless @credit_card.valid?
    begin
      @credit_card.save!
      current_user.activated!
      redirect_to confirm_dropin_reservations_path
    rescue => e
      logger.warn("#{e.class.name} #{e.message}")
      flash[:alert] = 'クレジットカードの登録に失敗しました'
      render :credit_card
    end
  end

  def create
    @dropin_reservation = DropinReservation.new_from_dropin_spot(session[:dropin_spot], @user, current_user)
    if @dropin_reservation.save
      session[:dropin_spot] = nil
      session[:reservation_id] = @dropin_reservation.id
      # NotificationMailer.reserved(@dropin_reservation, @dropin_reservation.user_id).deliver_now
      # NotificationMailer.reserved(@dropin_reservation, @dropin_reservation.reservation_user_id).deliver_now
      # NotificationMailer.reserved_to_admin(@dropin_reservation).deliver_now
      redirect_to thanks_dropin_reservations_path
    else
      flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
      redirect_to dropin_spot_reservations_path
    end
  end

  def thanks
    @dropin_reservation = DropinReservation.find(session[:reservation_id])
    @facility = @dropin_reservation.facility
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
