class FacilitiesController <  ApplicationController
  before_action :require_login
  before_action :set_user, only: [:index, :show]
  before_action :set_facility, only: [:show]

  def index
    @facilities = @user.available_facilities
  end

  def show; end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user
  end

  def set_facility
    @facility = @user.available_facilities.find(params[:id])
  end
end
