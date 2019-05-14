class Admin::FacilityKeysController < AdminController
  before_action :set_corporation
  before_action :set_shop
  before_action :set_facility
  before_action :set_facility_key, only: [:show, :edit, :update, :destroy]

  def new
    @facility_key = @facility.facility_keys.new
  end

  def create
    @facility_key = @facility.facility_keys.new(facility_key_params)
    @facility_key.set_name
    if @facility_key.save
      redirect_to [:admin, @corporation, @shop, @facility, @facility_key], notice: "#{FacilityKey.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @facility_key.assign_attribute(facility_key_params)
    @facility_key.set_name
    if @facility_key.save
      redirect_to [:admin, @corporation, @shop, @facility, @facility_key], notice: "#{FacilityKey.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @facility_key.destroy
    redirect_to admin_corporation_shop_facility_path(@corporation, @shop, @facility), notice: "#{FacilityKey.model_name.human}を削除しました"
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_shop
    @shop = @corporation.shops.find(params[:shop_id])
  end

  def set_facility
    @facility = @shop.facilities.find(params[:facility_id])
  end
  
  def set_facility_key
    @facility_key = @facility.facility_keys.find(params[:id])
  end

  def facility_key_params
    params.require(:facility_key).permit(
      :ks_room_key_id
    )
  end
end
