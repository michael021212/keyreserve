class FacilitiesController <  ApplicationController
  before_action :require_login
  before_action :set_facility, only: [:show]

  def index
    @facilities = current_user.available_facilities
  end

  def show; end

  def resources
    facilities = Facility.includes(shop: :corporation).where(shops: { corporation_id: current_corporation.id })
    @plans = facilities.find(params[:id]).plans
  end

  private

  def set_facility
    @facility = current_user.available_facilities.find(params[:id])
  end
end
