class CorporationManage::UserCorpsController < CorporationManage::Base
  before_action :set_user_corp, only: %i[show edit update destroy]

  def index
    @q = current_corporation.user_corps.ransack(params[:q])
    @user_corps = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  def show; end

  def new
    @user_corp = current_corporation.user_corps.build
  end

  def edit; end

  def create
    @user_corp = current_corporation.user_corps.build(user_corp_params)
    @user_corp.set_corp_settings
    if @user_corp.save
      redirect_to corporation_manage_user_corp_path(@user_corp), notice: t('common.messages.created', name: UserCorp.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user_corp.assign_attributes(user_corp_params)
    @user_corp.set_corp_settings
    if @user_corp.save
      redirect_to corporation_manage_user_corp_path(@user_corp), notice: t('common.messages.updated', name: UserCorp.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_corp.destroy!
    redirect_to corporation_manage_user_corps_path, notice: t('common.messages.deleted', name: UserCorp.model_name.human)
  end

  private

  def set_user_corp
    @user_corp = current_corporation.user_corps.find(params[:id])
  end

  def user_corp_params
    params.require(:user_corp).permit(
      :email,
      :name,
      :tel,
      :max_user_num,
      :password,
      :password_confirmation
    ).merge(corporation_ids: [current_corporation.id])
  end
end
