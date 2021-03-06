class Admin::ShopsController < AdminController
  before_action :set_corporation
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  def new
    @shop = Shop.new
  end

  def create
    @shop = @corporation.shops.new(set_params)
    @shop.set_geocode
    if @shop.save
      redirect_to [:admin, @corporation, @shop], notice: "#{Shop.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    @shop.assign_attributes(set_params)
    @shop.set_geocode
    if @shop.save
      redirect_to [:admin, @corporation, @shop], notice: "#{Shop.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to admin_corporation_path(@corporation)
  end

  private

  def set_params
    if shop_params[:disclosure_range] != 'for_chose_plan_users'
      shop_params_to_variable = shop_params
      shop_params_to_variable[:plan_ids].clear
      shop_params_to_variable
    else
      shop_params
    end
  end

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_shop
    @shop = @corporation.shops.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(
      :name, :postal_code, :address, :lat, :lon, :tel, :opening_time, :closing_time, :image, :calendar_url, :registerable, :disclosure_range, {plan_ids: []}
    )
  end
end
