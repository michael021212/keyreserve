class CorporationManage::FacilitiesController < CorporationManage::Base
  before_action :set_shop
  before_action :set_facility, only: %i[show edit update destroy facility_events]

  def show
    gon.schedular_licence_key = ENV['SCHEDULER_LICENCE_KEY']
    gon.shop_id = @shop.id
    gon.opening_time = @shop.opening_time
    gon.closing_time = @shop.closing_time
    gon.facility_id = @facility.id
  end

  def new
    @facility = @shop.facilities.build
  end

  def create
    @facility = @shop.facilities.build(facility_params)
    @facility.set_max_num
    @facility.set_geocode
    @facility.chartered_facilities.delete_all if !@facility.chartered
    if @facility.save
      redirect_to corporation_manage_shop_facility_path(@shop, @facility), notice: t('common.messages.created', name: Facility.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @facility.assign_attributes(facility_params)
    @facility.set_max_num
    @facility.set_geocode
    @facility.chartered_facilities.delete_all if !@facility.chartered
    if @facility.save
      redirect_to corporation_manage_shop_facility_path(@shop, @facility), notice: t('common.messages.updated', name: Facility.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @facility.destroy!
    redirect_to corporation_manage_shop_path(@shop), notice: t('common.messages.deleted', name: Facility.model_name.human)
  end

  # GET /corporation_manager/shops/:shop_id/facilities/:facility_id/facility_events (format: json)
  def facility_events
    @reservations = @facility.reservations
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
      :image_cache,
      :detail_document,
      :detail_document_cache,
      :description,
      :published,
      :max_num,
      :facility_type,
      :reservation_type,
      :address,
      :lat,
      :lon,
      :ks_room_id,
      :chartered,
      chartered_facilities_attributes: [:id, :facility_id, :child_facility_id, :_destroy],
      facility_plans_attributes: [:id, :plan_id, :_destroy]
    )
  end
end
