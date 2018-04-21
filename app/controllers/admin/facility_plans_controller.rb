class Admin::FacilityPlansController < AdminController
  before_action :set_corporation
  before_action :set_facility
  before_action :set_facility_plan, only: [:destroy]

  def new
    @facility_plan = @facility.facility_plans.new
  end

  def create
    @facility_plan = @facility.facility_plans.new(facility_plan_params)
    if @facility_plan.save
      redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{Facility.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def destroy
    @facility_plan.destroy
    redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{Facility.model_name.human}を削除しました"
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_facility
    @facility = Facility.find(params[:facility_id])
  end

  def set_facility_plan
    @facility_plan = FacilityPlan.find(params[:id])
  end

  def facility_plan_params
    params.require(:facility_plan).permit(
      :plan_id
    )
  end
end
