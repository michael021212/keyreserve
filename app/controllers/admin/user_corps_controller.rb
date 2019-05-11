class Admin::UserCorpsController < AdminController
  before_action :set_user_corp, only: [:show, :edit, :update, :destroy]

  def index
    @q = UserCorp.ransack(params[:q])
    @user_corps = @q.result(distinct: true).parent_corporation.order(id: :desc).page(params[:page])
  end

  def new
    @user_corp = UserCorp.new
  end

  def edit; end

  def create
    @user_corp = UserCorp.new(user_corp_params)
    @user_corp.set_corp_settings
    if @user_corp.save
      redirect_to admin_user_corp_path(@user_corp), notice: t('common.messages.created', name: UserCorp.model_name.human)
    else
      render :new
    end
  end

  def update
    @user_corp.assign_attributes(user_corp_params)
    @user_corp.set_corp_settings
    if @user_corp.save
      redirect_to admin_user_corp_path(@user_corp), notice: t('common.messages.updated', name: UserCorp.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @user_corp.destroy
    flash[:notice] = "#{UserCorp.model_name.human}を削除しました。"
    redirect_to admin_user_corps_path
  end

  private

  def set_user_corp
    @user_corp = UserCorp.find(params[:id])
  end

  def user_corp_params
    params.require(:user_corp).permit(
      :email,
      :name,
      :tel,
      :max_user_num,
      :password,
      :password_confirmation
    )
  end
end
