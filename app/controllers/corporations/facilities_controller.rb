class Corporations::FacilitiesController < ApplicationController
  before_action :set_shop
  before_action :set_facility, only: [:show, :edit, :update, :destroy]

  def new
    @facility = @shop.facilities.new
  end

  def create
    @facility = @shop.facilities.new(facility_params)
    if @facility.save
      redirect_to corporations_shop_facility_path(@shop, @facility), notice: "#{Facility.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @facility.update(facility_params)
      redirect_to corporations_shop_facility_path(@shop, @facility), notice: "#{Facility.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @facility.destroy
    redirect_to corporations_shop_path(@shop), notice: "#{Facility.model_name.human}を削除しました"
  end

  private

  def set_shop
    @shop = current_corporation.shops.find(params[:shop_id])
  end

  def set_facility
    @facility = @shop.facilities.find(params[:id])
  end

  def facility_params
    params.require(:facility).permit(
      :name,
      facility_plans_attributes: [:id, :plan_id, '_destroy']
    )
  end
end
