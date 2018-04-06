class Admin::FacilityTemporaryPlansController < AdminController
  before_action :set_corporation
  before_action :set_facility
  before_action :set_facility_temporary_plans

  def new
    @facility_temporary_plan = @facility.facility_temporary_plans.new
  end

  def create
    @facility_temporary_plan = @facility.facility_temporary_plans.new(facility_temporary_plan_params)
    if @facility_temporary_plan.save
      redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{FacilityTemporaryPlan.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def resources; end

  def events
    @facility_temporary_plans = FacilityTemporaryPlan.includes(facility: { shop: :corporation }).where(facilities: { shops: { corporation_id: @corporation.id }})
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_facility
    @facility = Facility.belong_to_corporation(@corporation).find(params[:facility_id])
  end

  def set_facility_temporary_plans
    @facility_temporary_plans = @facility.facility_temporary_plans
  end

  def facility_temporary_plan_params
    params.require(:facility_temporary_plan).permit(
      :plan_id, :standard_price_per_hour, :standard_price_per_day,
      facility_temporary_plan_prices_attributes: [
        :id, :facility_temporary_plan_id, :starting_time, :ending_time, :price
      ]
    )
  end
end
