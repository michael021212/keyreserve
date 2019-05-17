class CorporationManage::FacilityKeysController < CorporationManage::Base
  before_action :set_shop
  before_action :set_facility
  before_action :set_facility_key, only: %i[show edit update destroy]

  def new
    @facility_key = @facility.facility_keys.build
  end

  def create
    @facility_key = @facility.facility_keys.build(facility_key_params)
    @facility_key.set_name
    if @facility_key.save
      redirect_to corporation_manage_shop_facility_facility_key_path(@shop, @facility, @facility_key),
                  notice: t('common.messages.created', name: FacilityKey.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @facility_key.assign_attributes(facility_key_params)
    @facility_key.set_name
    if @facility_key.save
      redirect_to corporation_manage_shop_facility_facility_key(@shop, @facility, @facility_key),
                  notice: t('common.messages.created', name: FacilityKey.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    @facility_key.destroy!
    redirect_to corporation_manage_shop_facility_path(@shop, @facility),
                notice: t('common.messages.deleted', name: FacilityKey.model_name.human)
  end

  private

  def set_shop
    @shop = current_corporation.shops.find(params[:shop_id])
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
