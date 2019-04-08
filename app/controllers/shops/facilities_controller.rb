class Shops::FacilitiesController <  ApplicationController
  include SearchParams

  before_action :require_login, only: [:new, :create]
  before_action :set_user
  before_action :set_facility
  before_action :set_shop

  def new; end

  def create
    @condition = params[:spot]
    return render :new if @condition.blank?
    return render :new unless valid_search_params?(@condition) #@checkinと@checkoutもset
    if Reservation.where(facility_id: @facility.id).in_range(@checkin .. @checkout).blank?
      session[:spot] = @condition
      redirect_to confirm_reservations_url(page: :shop)
    else
      flash.now[:alert] = 'ご指定の時間は既に予約されています'
      render :new
    end
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
