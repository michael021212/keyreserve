class ShopsController <  ApplicationController
  before_action :set_user
  before_action :set_shop, only: [:show]

  def index
    @shops = Shop.where.not(is_rent: true).order(id: :desc).page(params[:page])
  end

  def show
    if @shop.for_rent?
      @rent_facilities = Facility
                         .displayale_rent_facilities
                         .where(published: true)
                         .order(id: :desc)
                         .page(params[:page])
    else
      @facilities = @shop
                    .facilities
                    .conference_room
                    .where(published: true)
                    .order(id: :desc)
                    .page(params[:page])
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
