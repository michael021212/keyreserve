class FacilitiesController <  ApplicationController
  before_action :require_login
  before_action :set_user, only: [:index, :show]
  before_action :set_facility, only: [:show]

  def index
    @facilities = @user.under_contract_facilities
  end

  def show; end

  def index_spot
    params[:spot] ||= {}
    cond = params[:spot]
    if cond.blank? || cond[:checkin].blank? || cond[:use_hour].blank?
      return render :index_spot
    end
    checkin = cond[:checkin]
    checkout = Time.zone.parse(cond[:checkin]) + cond[:use_hour].to_i.hours
    @exclude_facility_ids = Reservation.in_range(checkin .. checkout).pluck(:facility_id).uniq

    @facilities = logged_in? ? current_user.login_spots : Facility.logout_spots
    @facilities = @facilities.where.not(id: @exclude_facility_ids)
    @facilities = @facilities.order(id: :desc).page(params[:page])
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user
  end

  def set_facility
    @facility = @user.under_contract_facilities.find(params[:id])
  end
end
