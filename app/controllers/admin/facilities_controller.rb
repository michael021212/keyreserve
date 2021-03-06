class Admin::FacilitiesController < AdminController
  before_action :set_corporation
  before_action :set_shop, except: [:events]
  before_action :set_facility, only: [:show, :edit, :update, :destroy]
  before_action :set_facility_pack_plans, only: [:show]

  def new
    @facility = @shop.facilities.new
  end

  def create
    @facility = @shop.facilities.new(facility_params)
    @facility.set_geocode
    @facility.set_chartered
    if @facility.save
      redirect_to [:admin, @corporation, @shop, @facility], notice: "#{Facility.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @facility.assign_attributes(facility_params)
    @facility.set_geocode
    @facility.set_chartered
    @facility.chartered_facilities.delete_all if !@facility.chartered
    if @facility.save
      redirect_to [:admin, @corporation, @shop, @facility], notice: "#{Facility.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @facility.destroy!
    redirect_to admin_corporation_shop_path(@corporation, @shop), notice: "#{Facility.model_name.human}を削除しました"
  end

  def events
    @facility = Facility.find(params[:id])
    @reservations = @facility.reservations
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_shop
    @shop = @corporation.shops.find(params[:shop_id])
  end

  def set_facility
    @facility = @shop.facilities.find(params[:id])
  end

  def set_facility_pack_plans
    @q = @facility.facility_pack_plans.ransack(params[:q])
    @facility_pack_plans = @q.result(distinct: true)
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
      :checkin_time_for_stay,
      :checkout_time_for_stay,
      :chartered,
      chartered_facilities_attributes: [:id, :facility_id, :child_facility_id, :_destroy],
      facility_plans_attributes: [:id, :plan_id, '_destroy']
    )
  end
end
