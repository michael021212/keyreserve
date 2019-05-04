class CorporationManage::FacilityDropinPlansController < CorporationManage::Base
  before_action :set_facility
  before_action :set_facility_dropin_plan, only: %i[edit update destroy]
  before_action :set_facility_dropin_plans, only: %i[resources events]

  def new
    @facility_dropin_plan = @facility.facility_dropin_plans.build
  end

  def create
    @facility_dropin_plan = @facility.facility_dropin_plans.build(facility_dropin_plan_params)
    if @facility_dropin_plan.save
      redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: "#{FacilityDropinPlan.model_name.human}を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @facility_dropin_plan.update(facility_dropin_plan_params)
      redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: "#{FacilityDropinPlan.model_name.human}を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @facility_dropin_plan.destroy!
    redirect_to corporation_manage_shop_facility_path(@facility.shop, @facility), notice: "#{FacilityDropinPlan.model_name.human}を削除しました。"
  end

  def resources; end

  def events; end

  private

  def set_facility
    @facility = Facility.belongs_to_corporation(current_corporation).find(params[:facility_id])
  end

  def set_facility_dropin_plan
    @facility_dropin_plan = @facility.facility_dropin_plans.find(params[:id])
  end

  def set_facility_dropin_plans
    @facility_dropin_plans = @facility.facility_dropin_plans
  end

  def facility_dropin_plan_params
    params.require(:facility_dropin_plan).permit(
      :plan_id,
      :guide_mail_title,
      :guide_mail_content,
      :guide_file,
      facility_dropin_sub_plans_attributes: [
        :id,
        :facility_dropin_plan_id,
        :name,
        :starting_time,
        :ending_time,
        :price,
        :_destroy
      ]
    )
  end
end
