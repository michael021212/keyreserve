class UserContractsController < ApplicationController
  before_action :set_shop, :set_facility, :set_plan

  def new
    @user_contract = UserContract.new
  end

  def create; end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_facility
    @facility = Facility.find(params[:facility_id])
  end

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end
