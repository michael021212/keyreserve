class FacilitiesController <  ApplicationController
  before_action :require_login
  before_action :set_user, only: [:index, :show]
  before_action :set_facility, only: [:show]

  def index
    @facilities = @user.under_contract_facilities
  end

  def show; end

  def index_spot
    @facilities = logged_in? ? Facility.login_spots(current_user) : Facility.logout_spots
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
