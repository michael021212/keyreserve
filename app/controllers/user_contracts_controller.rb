class UserContractsController < ApplicationController
  before_action :set_shop, only: [:new, :create, :credit_card]
  before_action :set_plan, only: [:new, :create, :credit_card]
  before_action :set_facilities, only: [:new, :credit_card]
  before_action :set_user_contract, only: [:show]

  def new; end

  def create
    @user_contract = current_user.user_contracts.new(user_contract_params)
    @user_contract.corporation_id = @user_contract.shop.corporation_id
    @user_contract.started_on = Time.zone.now
    if @user_contract.save
      @user_contract.corporation.users.each do |cu|
        NotificationMailer.new_user_contract(cu, @user_contract).deliver_now
      end
      redirect_to user_contract_path(@user_contract), notice: "#{UserContract.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def show; end

  def credit_card
    @user_contract = current_user.user_contracts.build
  end

  private

  def set_shop
    @shop = if params[:shop_name].present?
              Shop.find_by(name: params[:shop_name])
            else
              Shop.find(params[:user_contract][:shop_id])
            end
  end

  def set_plan
    @plan = if params[:plan_name].present?
              Plan.find_by(name: params[:plan_name])
            else
              Plan.find(params[:user_contract][:plan_id])
            end
  end

  def set_facilities
    @facilities = @plan.facilities
  end

  def set_user_contract
    @user_contract = current_user.user_contracts.find(params[:id])
  end

  def user_contract_params
    params.require(:user_contract).permit(
      :plan_id, :shop_id
    )
  end
end
