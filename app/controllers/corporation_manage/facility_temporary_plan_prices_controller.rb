class CorporationManage::FacilityTemporaryPlanPricesController < CorporationManage::Base
  def index
    @shop = current_corporation.shops.find(params[:shop_id])
    @facility = @shop.facilities.find(params[:facility_id])
    @facility_temporary_plans = @facility.facility_temporary_plans
    @facility_temporary_plan_prices = @facility.facility_temporary_plan_prices
  end
end
