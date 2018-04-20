class FacilitiesController <  ApplicationController
  before_action :require_login, only: [:index, :show]
  before_action :set_facility, only: [:show]

  def index
    @facilities = current_user.available_facilities.order(id: :desc).page(params[:page])
  end

  def show; end

  def index_spot
    @facilities = logged_in? ? Facility.login_spots(current_user) : Facility.logout_spots
    @facilities = @facilities.order(id: :desc).page(params[:page])
  end

  private

  def set_facility
    @facility = current_user.available_facilities.find(params[:id])
  end
end
