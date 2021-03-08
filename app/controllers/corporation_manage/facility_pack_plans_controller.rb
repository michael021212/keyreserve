class CorporationManage::FacilityPackPlansController < CorporationManage::Base
  before_action :set_shop
  before_action :set_facility
  before_action :set_facility_pack_plan, only: [:edit, :update, :destroy]

  def new
    @facility_pack_plan = @facility.facility_pack_plans.new
  end

  def create
    @facility_pack_plan = @facility.facility_pack_plans.new(facility_pack_plan_params)
    if @facility_pack_plan.save
      redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: "#{FacilityPackPlan.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @facility_pack_plan.update(facility_pack_plan_params)
      redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: "#{FacilityPackPlan.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @facility_pack_plan.destroy
    redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: "#{FacilityPackPlan.model_name.human}を削除しました。"
  end

  private

  def set_shop
    @shop = current_corporation.shops.find(params[:shop_id])
  end

  def set_facility
    @facility = @shop.facilities.find(params[:facility_id])
  end

  def set_facility_pack_plans
    @facility_pack_plans = @facility.facility_pack_plans
  end

  def set_facility_pack_plan
    @facility_pack_plan = @facility.facility_pack_plans.find(params[:id])
  end

  def facility_pack_plan_params
    params.require(:facility_pack_plan).permit(
      :plan_id, :ks_room_key_id, :guide_mail_title, :guide_mail_content, :guide_file, :unit_time, :unit_price
    )
  end
end
