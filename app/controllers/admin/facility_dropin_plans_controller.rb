class Admin::FacilityDropinPlansController < AdminController
  before_action :set_corporation
  before_action :set_facility
  before_action :set_facility_dropin_plan, only: [:edit, :update, :destroy]
  before_action :set_facility_dropin_plans, only: [:resources, :events]

  def new
    @facility_dropin_plan = @facility.facility_dropin_plans.new
  end

  def create
    @facility_dropin_plan = @facility.facility_dropin_plans.new(facility_dropin_plan_params)
    if @facility_dropin_plan.save
      redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{FacilityDropinPlan.model_name.human}を更新しました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @facility_dropin_plan.update(facility_dropin_plan_params)
      redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{FacilityDropinPlan.model_name.human}を作成しました。"
    else
      render :edit
    end
  end

  def destroy
    @facility_dropin_plan.destroy
    redirect_to admin_corporation_shop_facility_path(@corporation, @facility.shop, @facility), notice: "#{FacilityDropinPlan.model_name.human}を削除しました。"
  end

  def resources; end

  def events; end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_facility
    @facility = Facility.belongs_to_corporation(@corporation).find(params[:facility_id])
  end

  def set_facility_dropin_plan
    @facility_dropin_plan = @facility.facility_dropin_plans.find(params[:id])
  end

  def set_facility_dropin_plans
    @facility_dropin_plans = @facility.facility_dropin_plans
  end

  def facility_dropin_plan_params
    params.require(:facility_dropin_plan).permit(
      :plan_id, :ks_room_key_id, :guide_mail_title, :guide_mail_content, :guide_file, :usage_fee_per_hour,
      facility_dropin_sub_plans_attributes: [
        :id, :facility_dropin_plan_id, :name, :starting_time, :ending_time, :price, :_destroy],
      dropin_keys_attributes: [
        :id, :facility_dropin_plan_id, :ks_room_key_id, :name, :_destroy
      ]
    )
  end
end
