class FacilitiesController <  ApplicationController
  before_action :require_login
  before_action :set_facility, only: [:show]

  def index
    @facilities = current_user.available_facilities
  end

  def show; end

  def resources
    facilities = Facility.belong_to_corporation(current_corporation)
    @plans = facilities.find(params[:id]).plans
  end

  private

  def set_facility
    if params[:corporation_name].present?
      @facility = Facility.belong_to_corporation(current_corporation).find(params[:id])
    else
      @facility = current_user.available_facilities.find(params[:id])
    end
  end
end
