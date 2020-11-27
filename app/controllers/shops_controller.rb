class ShopsController <  ApplicationController
  before_action :set_user
  before_action :set_shop, only: [:show]

  def index
    @shops = Shop
              .where(shop_type: [Shop.shop_types[:general], Shop.shop_types[:general_with_ksc]])
              .order(id: :desc)
              .page(params[:page])
    @shops = @shops.where(corporation_id: current_user.corporation_ids) if current_user.present? && current_user.related_corp_facilities?
    # ザイマックス店舗・リフカム店舗は一般公開しない
    @shops = @shops.where.not(id: Shop::WBG_SHOP_ID) if current_user.blank? || !current_user.contract_plan_ids.include?(26)
    @shops = @shops.where.not(id: Shop::REFCOME_SHOP_ID) if current_user.blank? || !current_user.contract_plan_ids.include?(30)
  end

  def show
    if @shop.for_rent?
      @rent_facilities = Facility
                         .displayale_rent_facilities
                         .where(published: true)
                         .order(id: :desc)
                         .page(params[:page])
    elsif @shop.for_flexible?
      flexible_shops = current_user.corporations.map{|c| c.shops.ks_flexible}.flatten
      @flexible_facilities = Facility
                            .ks_flexible
                            .where(shop_id: flexible_shops.map{|s| s.id})
                            .where(published: true)
                            .order(id: :desc)
                            .page(params[:page])
    elsif @shop.for_public?
      if current_user.present?
        @public_facilities = current_user
                            .login_spots
                            .public_place
                            .where(published: true)
                            .order(id: :desc)
                            .page(params[:page])
      else
        @public_facilities = []
      end
    else
      if current_user.present?
        @facilities = current_user
                      .login_spots
                      .conference_room
                      .where(shop_id: @shop.id)
                      .where(published: true)
                      .order(id: :asc)
                      .page(params[:page])
      else
        @facilities = []
      end
    end
  end

  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end
end
