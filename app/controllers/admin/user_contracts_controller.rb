class Admin::UserContractsController < AdminController
  before_action :set_corporation
  before_action :set_user_contract, only: [:show, :edit, :update, :destroy]

  def index
    @user_contracts = @corporation.user_contracts.order(id: :desc).page(params[:page])
  end

  def new
    @user_contract = @corporation.user_contracts.new
  end

  def create
    @user_contract = @corporation.user_contracts.new(user_contract_params)
    if @user_contract.save
      redirect_to [:admin, @corporation, @user_contract], notice: "#{UserContract.model_name.human}を作成しました。"
    else
      render :new
    end 
  end

  def show; end
  
  def edit; end

  def update
    if @user_contract.update(user_contract_params)
      redirect_to [:admin, @corporation, @user_contract], notice: "#{UserContract.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @user_contract.destroy
    redirect_to admin_corporation_path(@corporation)
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_user_contract
    @user_contract = @corporation.user_contracts.find(params[:id])
  end

  def user_contract_params
    params.require(:user_contract).permit(
      :shop_id, :user_id, :plan_id, :started_on, :finished_on, :state
    )
  end
end
