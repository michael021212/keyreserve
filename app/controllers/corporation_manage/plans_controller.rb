class CorporationManage::PlansController < CorporationManage::Base
  before_action :set_plan, only: %i[show edit update destroy]

  def index
    @plans = current_corporation.plans.order(id: :desc).page(params[:page])
  end

  def new
    @plan = current_corporation.plans.build
  end

  def create
    @plan = current_corporation.plans.build(plan_params)
    if @plan.save
      redirect_to corporation_manage_plan_path(@plan), notice: "#{Plan.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @plan.update(plan_params)
      redirect_to corporation_manage_plan_path(@plan), notice: "#{Plan.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @plan.destroy!
    redirect_to corporation_manage_plans_path, notice: "#{Plan.model_name.human}を削除しました。"
  end

  private

  def set_plan
    @plan = current_corporation.plans.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(
      :name,
      :price,
      :description,
      :default_flag
    )
  end
end
