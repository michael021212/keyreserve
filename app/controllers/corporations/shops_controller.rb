class Corporations::ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update]

  def index
    @shops = current_corporation.shops.order(id: :desc).page(params[:page])
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = current_corporation.shops.new(shop_params)
    if @shop.save
      redirect_to corporations_shop_path(@shop), notice: "#{Shop.model_name.human}を作成しました。"
    else
      render :new
    end 
  end

  def show; end
  
  def edit; end

  def update
    if @shop.update(shop_params)
      redirect_to corporations_shop_path(@shop), notice: "#{Shop.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  private

  def set_shop
    @shop = current_corporation.shops.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(
      :name, :postal_code, :address, :lat, :lon, :tel, :opening_time, :closing_time
    )
  end
end
