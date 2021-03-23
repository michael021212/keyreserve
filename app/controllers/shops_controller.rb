class ShopsController < ApplicationController
  before_action :set_user
  before_action :set_shop, :set_facilities, :set_dropin_facilities, :set_accommodation_facilities, only: [:show]

  def index
    @q = Shop.available_shops(@user).ransack(params[:q])
    @shops = @q.result.order(id: :desc).page(params[:page])
  end

  def show
    if @shop.for_flexible?
      current_user_corporation_shops = Shop.where(corporation_id: current_user.corporations.pluck(:id))
      @flexible_facilities = Facility
                            .ks_flexible
                            .where(shop_id: current_user_corporation_shops.map{|s| s.id})
                            .where(published: true)
                            .order(id: :desc)
                            .page(params[:page])
    else
      @facilities = @facilities.order(id: :asc).page(params[:page])
      @dropin_facilities = @dropin_facilities.order(id: :asc).page(params[:page])
      @accommodation_facilities = @accommodation_facilities.order(id: :asc).page(params[:page])
    end
  end

  private

  def set_facilities
    @facilities = current_user.present? ? current_user.conference_room_facilities(@shop) : @shop.facilities.conference_room_facilities
  end

  def set_dropin_facilities
    @dropin_facilities = current_user.present? ? current_user.dropin_facilities(@shop) : @shop.facilities.dropin_facilities
  end

  def set_accommodation_facilities
    @accommodation_facilities = current_user.present? ? current_user.accommodation_facilities(@shop) : @shop.facilities.accommodation_facilities
  end

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def set_shop
    @shop = Shop.available_shops(@user).find(params[:id])
  end
end
