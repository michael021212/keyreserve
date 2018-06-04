class Shops::FacilitiesController <  ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :set_user
  before_action :set_facility
  before_action :set_shop

  def new; end

  def create
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank?
      return render :new
    end
    checkin = Time.zone.parse(cond[:checkin] + " " + cond[:checkin_time])
    checkout = checkin + cond[:use_hour].to_i.hours
    opening = Time.zone.parse(cond[:checkin] + " " +  @shop.opening_time.to_time.to_s(:time))
    closing = Time.zone.parse(cond[:checkin] + " " +  @shop.closing_time.to_time.to_s(:time))

    if checkin < Time.zone.now - 30.minutes
      flash[:error] = 'ご予約はご利用の30分前までとなります'
      return render :new
    end

    if @facility.reservations.in_range(checkin..checkout).present?
      flash[:error] = 'このお時間帯は満室でございます'
      return render :new
    end

    if checkin < opening || checkout > closing
      flash[:error] = 'ご予約時間が営業時間外となります'
      return render :new
    end

    session[:spot] = params[:spot]
    redirect_to confirm_reservations_url
  end

  def events
    @start = params[:start]
    @end = params[:end]
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def set_facility
    @facility = Facility.find(params[:id])
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
