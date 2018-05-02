class ReservationsController <  ApplicationController
  before_action :set_user
  before_action :require_login, except: [:spots]
  include ActionView::Helpers::NumberHelper

  def spot
    params[:spot] ||= {}
    params[:spot][:checkin_time] ||= '12:00'
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank?
      return render :spot
    end
    checkin = Time.zone.parse(cond[:checkin] + " " + cond[:checkin_time])
    checkout = checkin + cond[:use_hour].to_i.hours
    @exclude_facility_ids = Reservation.in_range(checkin .. checkout).pluck(:facility_id).uniq

    @facilities = logged_in? ? @user.login_spots : Facility.logout_spots
    @facilities = @facilities.where.not(id: @exclude_facility_ids)
    @facilities = @facilities.where(max_num: cond[:use_num].to_i .. Float::INFINITY) if cond[:use_num].present?
    @facilities = @facilities.order(id: :desc).page(params[:page])
    session[:spot] = cond
  end

  def new
    params[:spot] ||= session[:spot]
    session[:reservation_id] = nil
    @facility = @user.login_spots.find(params[:facility_id]) if params[:facility_id].present?
  end

  def price
    @facility = @user.login_spots.find(params[:facility_id]) if params[:facility_id].present?
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank? || cond[:checkin_time].blank?
      return render json: {price: ''}
    end 
    checkin = Time.zone.parse(cond[:checkin] + " " + cond[:checkin_time])
    price = @facility.calc_price(@user, checkin, cond[:use_hour].to_i)
    render json: {price: number_with_delimiter(price)}
  end

  def credit_card
    @facility = Facility.find(session[:spot]['facility_id'].to_i)
    return redirect_to confirm_reservations_url if current_user.credit_card.present?
    @credit_card = @user.build_credit_card(credit_card_params)
    return(render :credit_card) unless @credit_card.valid?
    begin
      @credit_card.save!
      current_user.activated!
      redirect_to confirm_reservations_url
    rescue => e
      logger.warn("#{e.class.name} #{e.message}")
      flash[:alert] = 'クレジットカードの登録に失敗しました'
      render :credit_card
    end
  end

  def confirm
    session[:spot] = params[:spot] if params[:spot].present?
    @facility = Facility.find(session[:spot]['facility_id'].to_i)
    checkin = Time.zone.parse(session[:spot]['checkin'] + " " + session[:spot]['checkin_time'])
    @price = @facility.calc_price(@user, checkin, session[:spot]['use_hour'].to_i)
      if @user.credit_card.blank? && @user.creditcard?
      @credit_card = current_user.build_credit_card
      return render :credit_card
    end
  end

  def create
    @reservation = Reservation.new_from_spot(session[:spot], @user.credit_card)
    if @reservation.save!
      session[:spot] = nil
      session[:reservation_id] = @reservation.id
      NotificationMailer.reserved(@reservation).deliver_now
      redirect_to thanks_reservations_url
    else
      flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
      redirect_to spot_reservations_url
    end
  end

  def thanks
    @reservation = Reservation.find(session[:reservation_id])
    @facility = @reservation.facility
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
