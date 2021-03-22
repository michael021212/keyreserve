class ShopsController < ApplicationController
  before_action :set_user
  before_action :set_shop, only: [:show]

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
      if current_user.present?
        @facilities = current_user
                      .login_spots
                      .conference_room
                      .where(shop_id: @shop.id)
                      .where(published: true)
                      .order(id: :asc)
                      .page(params[:page])
        @dropin_facilities = current_user
                            .login_dropin_spots
                            .where(shop_id: @shop.id)
                            .where(published: true)
                            .order(id: :asc)
                            .page(params[:page])
        @accommodation_facilities = current_user
                                    .login_spots
                                    .accommodation
                                    .where(shop_id: @shop.id)
                                    .where(published: true)
                                    .order(id: :asc)
                                    .page(params[:page])
      else
        @facilities = @shop.facilities
                      .logout_spots
                      .conference_room
                      .where(published: true)
                      .order(id: :asc)
                      .page(params[:page])
        @dropin_facilities = @shop
                      .facilities
                      .logout_dropin_spots
                      .where(published: true)
                      .order(id: :asc)
                      .page(params[:page])
        @accommodation_facilities = @shop
                      .facilities
                      .logout_spots
                      .accommodation
                      .where(published: true)
                      .order(id: :asc)
                      .page(params[:page])
      end
    end
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def set_shop
    @shop = Shop.available_shops(@user).find(params[:id])
  end
end
