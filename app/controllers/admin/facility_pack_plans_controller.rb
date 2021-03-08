class Admin::FacilityPackPlansController < AdminController
  before_action :set_corporation
  before_action :set_facility
  before_action :set_facility_pack_plan, only: [:edit, :update, :destroy]

  def new
    @facility_pack_plan = @facility.facility_pack_plans.new
  end

  def create
    @facility_pack_plan = @facility.facility_pack_plans.new(facility_pack_plan_params)
    if @facility_pack_plan.save
      redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{FacilityPackPlan.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @facility_pack_plan.update(facility_pack_plan_params)
      redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{FacilityPackPlan.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @facility_pack_plan.destroy
    redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{FacilityPackPlan.model_name.human}を削除しました。"
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_facility
    @facility = Facility.belongs_to_corporation(@corporation).find(params[:facility_id])
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
