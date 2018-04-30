class ReservationsController <  ApplicationController
  before_action :set_user
  before_action :require_login, except: [:spots]
  before_action :set_facility, except: [:spot]
  include ActionView::Helpers::NumberHelper

  def spot
    params[:spot] ||= {}
    params[:spot][:checkin_time] ||= '12:00'
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank?
      return render :spot
    end
    checkin = cond[:checkin]
    checkout = Time.zone.parse(cond[:checkin]) + cond[:use_hour].to_i.hours
    @exclude_facility_ids = Reservation.in_range(checkin .. checkout).pluck(:facility_id).uniq

    @facilities = logged_in? ? @user.login_spots : Facility.logout_spots
    @facilities = @facilities.where.not(id: @exclude_facility_ids)
    @facilities = @facilities.where(max_num: cond[:use_num].to_i .. Float::INFINITY) if cond[:use_num].present?
    @facilities = @facilities.order(id: :desc).page(params[:page])
    session[:spot] = cond
  end

  def new
    params[:spot] ||= session[:spot]
  end

  def price
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank? || cond[:checkin_time].blank?
      return render json: {price: ''}
    end 
    checkin = DateTime.parse(cond[:checkin] + " " + cond[:checkin_time])
    price = @facility.calc_price(@user, checkin, cond[:use_hour].to_i)
    render json: {price: number_with_delimiter(price)}
  end

  def credit_card
    @credit_card = current_user.build_credit_card(credit_card_params)
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
    if @user.credit_card.blank? || params[:change_card].present?
      return render :credit_card
    end
  end

  def create
    @reservation = Reservation.new_from_spot(session[:spot], @user.credit_card)
    if @reservation.save
      redirect_to thanks_reservations_url
    else
      flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
      redirect_to spot_reservations_url
    end
  end

  def thanks
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def set_facility
    @facility = @user.login_spots.find(params[:facility_id])
  end
end
