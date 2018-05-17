class Shops::FacilitiesController <  ApplicationController
  before_action :set_shop
  before_action :set_facility

  def show; end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_facility
    @facility = Facility.find(params[:id])
  end
end
