class CorporationManage::UserContractsController < CorporationManage::Base
  before_action :set_user_contract, only: %i[show edit update destroy]

  def index
    @user_contracts = current_corporation.user_contracts.order(id: :desc).page(params[:page])
  end

  def new
    @user_contract = current_corporation.user_contracts.build
  end

  def create
    @user_contract = current_corporation.user_contracts.build(user_contract_params)
    if @user_contract.save
      redirect_to corporation_manage_user_contract_path(@user_contract), notice: "#{UserContract.model_name.human}を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @user_contract.update(user_contract_params)
      redirect_to corporation_manage_user_contract_path(@user_contract), notice: "#{UserContract.model_name.human}を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_contract.destroy!
    redirect_to corporation_manage_user_contracts_path, notice: "#{UserContract.model_name.human}を削除しました。"
  end

  private

  def set_user_contract
    @user_contract = current_corporation.user_contracts.find(params[:id])
  end

  def user_contract_params
    params.require(:user_contract).permit(
      :shop_id,
      :user_id,
      :plan_id,
      :started_on,
      :finished_on,
      :state
    )
  end
end
