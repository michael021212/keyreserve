class FacilityTemporaryPlansController <  ApplicationController
  before_action :set_facility
  before_action :set_facility_temporary_plans

  def new
    @facility_temporary_plan = @facility.facility_temporary_plans.new
  end

  def create
    @facility_temporary_plan = @facility.facility_temporary_plans.new(facility_temporary_plan_params)
    if @facility_temporary_plan.save
      redirect_to facility_path(@facility, corporation_name: current_corporation.name), notice: "#{FacilityTemporaryPlan.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def resources; end

  private

  def set_facility
    @facility = Facility.belong_to_corporation(current_corporation).find(params[:facility_id])
  end

  def set_facility_temporary_plans
    @facility_temporary_plans = @facility.facility_temporary_plans
  end

  def facility_temporary_plan_params
    params.require(:facility_temporary_plan).permit(
      :plan_id, :standard_price_per_hour, :standard_price_per_day
    )
  end
end
