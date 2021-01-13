class ShopsController < ApplicationController
  before_action :set_user
  before_action :set_shop, only: [:show]
  before_action :require_login, only: [:show]
  before_action :require_sms_verification, only: [:show]

  def index
    shops = Shop.filter_by_disclosure_range(@user)
    @shops = shops.to_activerecord_relation
    @shops = @shops.chooseable_shops(@user).order(id: :desc).page(params[:page])
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
      @facilities = current_user
                    .login_spots
                    .conference_room
                    .where(shop_id: @shop.id)
                    .where(published: true)
                    .order(id: :asc)
                    .page(params[:page])
    end
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def set_shop
    @shop = Shop.filter_by_disclosure_range(@user)
                .to_activerecord_relation
                .chooseable_shops(@user).find(params[:id])
  end
end
