class CorporationManage::ShopsController < CorporationManage::Base
  before_action :set_shop, only: %i[show edit update destroy]

  def new
    @shop = current_corporation.shops.build
  end

  def create
    @shop = current_corporation.shops.build(set_params)
    @shop.set_geocode
    if @shop.save
      redirect_to corporation_manage_shop_path(@shop), notice: "#{Shop.model_name.human}を作成しました。"
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
      redirect_to corporation_manage_shop_path(@shop), notice: "#{Shop.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy!
    redirect_to corporation_manage_root_path, notice: "#{Shop.model_name.human}を削除しました。"
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

  def set_shop
    @shop = current_corporation.shops.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(
      :name,
      :postal_code,
      :address,
      :lat,
      :lon,
      :tel,
      :opening_time,
      :closing_time,
      :image,
      :calendar_url,
      :registerable,
      :disclosure_range,
      {plan_ids: []}
    )
  end
end
