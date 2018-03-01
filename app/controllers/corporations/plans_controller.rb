class Corporations::PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :update, :destroy]

  def index
    @plans = current_corporation.plans.order(created_at: :desc).page(params[:page])
  end

  def new
    @plan = current_corporation.plans.new
  end

  def create
    @plan = current_corporation.plans.new(plan_params)
    if @plan.save
      redirect_to corporations_plans_path, notice: "#{Plan.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @plan.update(plan_params)
      redirect_to corporations_plans_path, notice: "#{Plan.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @plan.destroy
    redirect_to corporations_plans_path, notice: "#{Plan.model_name.human}を削除しました。" 
  end

  private

  def set_plan
    @plan = current_corporation.plans.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(
      :corporation_id, :name, :price
    )
  end
end
