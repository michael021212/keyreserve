class ShopsController <  ApplicationController
  before_action :set_shop, only: [:show]

  def index
    if params[:corporation_name].present?
      current_corporation = Corporation.find_by(name: params[:corporation_name])
      @shops = current_corporation.shops.order(id: :desc).page(params[:page])
    else
      @shops = Shop.order(id: :desc).page(params[:page])
    end
  end

  def show
    @facilities = @shop.facilities.order(id: :desc).page(params[:page])
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end
end
