class Corporations::FacilitiesController < ApplicationController
  before_action :set_shop
  before_action :set_facility, only: [:show, :edit, :update, :destroy]
  before_action :set_ks_room_key_ids, only: [:new, :edit]

  def new
    @facility = @shop.facilities.new
    @facility.facility_keys.build
  end

  def create
    @facility = @shop.facilities.new(facility_params)
    if @facility.save
      redirect_to corporations_shop_facility_path(@shop, @facility), notice: "#{Facility.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit
    if @ks_room_key_ids.present? && @facility.facility_keys.blank?
       @facility.facility_keys.build
    end
  end

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

  def set_ks_room_key_ids
    @ks_room_key_ids = Facility.sync_from_api(current_corporation.ks_corporation_id)
  end

  def facility_params
    params.require(:facility).permit(
      :shop_id, :name,
      facility_keys_attributes: [:id, :facility_id, :key_id, :name, :ks_room_key_id],
      facility_plans_attributes: [:id, :plan_id, '_destroy']
    )
  end
end
