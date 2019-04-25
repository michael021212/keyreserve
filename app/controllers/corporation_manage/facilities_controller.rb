class CorporationManage::FacilitiesController < CorporationManage::Base
  before_action :set_shop
  before_action :set_facility, only: %i[show edit update destroy]

  def show; end

  def new
    @facility = @shop.facilities.new
  end

  def create
    @facility = @shop.facilities.new(facility_params)
    @facility.set_geocode
    if @facility.save
      redirect_to corporation_manage_shop_facility_path(@shop, @facility), notice: "#{Facility.model_name.human}を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @facility.assign_attributes(facility_params)
    @facility.set_geocode
    if @facility.save
      redirect_to corporation_manage_shop_facility_path(@shop, @facility), notice: "#{Facility.model_name.human}を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @facility.destroy!
    redirect_to corporation_manage_shop_path(@shop), notice: "#{Facility.model_name.human}を削除しました"
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
      :shop_id,
      :name,
      :image,
      :description,
      :max_num,
      :facility_type,
      :address,
      :lat,
      :lon,
      facility_plans_attributes: [:id, :plan_id, :_destroy]
    )
  end
end
