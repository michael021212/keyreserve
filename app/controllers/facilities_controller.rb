class FacilitiesController <  ApplicationController
  before_action :require_login
  before_action :set_facility, only: [:show]

  def index
    if URI(request.referer).path == '/facilities'
      @facilities = current_user.available_facilities
    else
      @facilities = Facility.order(id: :desc).page(params[:page])
      render template: 'spot_facilities/index'
    end
  end

  def show; end

  private

  def set_facility
    @facility = current_user.available_facilities.find(params[:id])
  end
end
