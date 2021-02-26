class Shops::FacilitiesController <  ApplicationController
  include SearchParams

  before_action :require_login, only: [:new, :create]
  before_action :require_sms_verification, only: [:new, :create]
  before_action :set_user
  before_action :set_facility
  before_action :set_shop

  def new
    redirect_to root_path, alert: '現在掲載停止中の施設です。' if !@facility.published
    @condition = params[:spot] ||= {}
    set_choosable_pack_plans
  end

  def create
    @condition = params[:spot] ||= {}
    return render :new if @condition.blank?
    set_choosable_pack_plans
    set_selected_pack_plan_id(@condition)
    return render :new unless valid_search_params?(@condition) #@checkinと@checkoutもset
    session[:spot] = @condition
    redirect_to confirm_reservations_url(page: :shop)
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

  def set_choosable_pack_plans
    @choosable_pack_plans = @facility.choosable_pack_plans(@user).flatten.to_activerecord_relation
  end

  def set_selected_pack_plan_id(condition)
    @selected_pack_plan_id = @choosable_pack_plans.find_by(id: condition[:pack_plan_id]).id if condition[:pack_plan_id].present?
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
