class ShopsController <  ApplicationController
  before_action :set_user
  before_action :set_shop, only: [:show]

  def index
    @shops = Shop.where.not(is_rent: true).order(id: :desc).page(params[:page])
  end

  def show
    @facilities = @shop.facilities.order(id: :desc).page(params[:page])
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end
end
