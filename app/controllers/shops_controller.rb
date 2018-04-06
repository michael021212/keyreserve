class ShopsController <  ApplicationController
  before_action :set_shop, only: [:show]

  def index
    @shops = Shop.order(id: :desc).page(params[:page])
  end

  def show
    @facilities = @shop.facilities.order(id: :desc).page(params[:page])
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end
end
