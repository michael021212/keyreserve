class PlansController < ApplicationController
  before_action :set_corporation
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = @corporation.plans.order(id: :desc).page(params[:page])
  end

  def new
    @plan = @corporation.plans.new
  end

  def create
    @plan = @corporation.plans.new(plan_params)
    if @plan.save
      redirect_to plans_path, notice: "#{Plan.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: "#{Plan.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_path, notice: "#{Plan.model_name.human}を削除しました。"

  end

  private

  def set_corporation
    @corporation = current_corporation
  end

  def set_plan
    @plan = @corporation.plans.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(
      :name, :price, :description, :default_flag
    )
  end
end
