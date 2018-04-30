class FacilitiesController <  ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :require_login
  before_action :set_user, only: [:index, :show, :index_spot, :show_spot, :get_price]
  before_action :set_facility, only: [:show, :show_spot, :get_price]

  def index
    @facilities = @user.under_contract_facilities
  end

  def show; end

  def index_spot
    params[:spot] ||= {}
    params[:spot][:checkin_time] ||= '12:00'
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank?
      return render :index_spot
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

  def show_spot
    params[:spot] ||= session[:spot]
  end

  def get_price
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank? || cond[:checkin_time].blank?
      return render :index_spot
    end 
    checkin = DateTime.parse(cond[:checkin] + " " + cond[:checkin_time])
    price = @facility.calc_price(@user, checkin, cond[:use_hour].to_i)
    render json: {price: number_with_delimiter(price)}
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user
  end

  def set_facility
    @facility = @user.login_spots.find(params[:id])
  end
end
