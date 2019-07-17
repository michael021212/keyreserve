class FacilitiesController <  ApplicationController
  before_action :require_login
  before_action :require_sms_verification
  before_action :set_user, only: [:index, :show]
  before_action :set_facility, only: [:show]

  def index
    @facilities = @user
                  .available_facilities
                  .where(published: true)
  end

  def show
    redirect_to root_path, alert: '現在掲載停止中の施設です。' if !@facility.published
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user
  end

  def set_facility
    @facility = @user.available_facilities.find(params[:id])
  end
end
