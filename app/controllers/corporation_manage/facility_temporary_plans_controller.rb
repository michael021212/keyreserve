class CorporationManage::FacilityTemporaryPlansController < CorporationManage::Base
  before_action :set_shop
  before_action :set_facility
  before_action :set_facility_temporary_plan, only: %i[edit update destroy]

  def index
    @facility_temporary_plans = @facility.facility_temporary_plans
  end

  def new
    @facility_temporary_plan = @facility.facility_temporary_plans.build
  end

  def create
    @facility_temporary_plan = @facility.facility_temporary_plans.build(facility_temporary_plan_params)
    if @facility_temporary_plan.save
      redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: t('common.messages.created', name: FacilityTemporaryPlan.model_name.human)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @facility_temporary_plan.update(facility_temporary_plan_params)
      redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: t('common.messages.updated', name: FacilityTemporaryPlan.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @facility_temporary_plan.destroy!
    redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: t('common.messages.deleted', name: FacilityTemporaryPlan.model_name.human)
  end

  private

  def set_shop
    @shop = current_corporation.shops.find(params[:shop_id])
  end

  def set_facility
    @facility = @shop.facilities.find(params[:facility_id])
  end

  def set_facility_temporary_plan
    @facility_temporary_plan = @facility.facility_temporary_plans.find(params[:id])
  end

  def facility_temporary_plan_params
    params.require(:facility_temporary_plan).permit(
      :plan_id,
      :ks_room_key_id,
      :guide_mail_title,
      :guide_mail_content,
      :guide_file,
      :standard_price_per_hour,
      :standard_price_per_day,
      facility_temporary_plan_prices_attributes: [
        :id,
        :facility_temporary_plan_id,
        :starting_time,
        :ending_time,
        :price,
        :_destroy
      ]
    )
  end
end
