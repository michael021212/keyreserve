class CorporationManage::CorporateAdminUsersController < CorporationManage::Base
  before_action :set_corporate_admin_user, only: %i[show edit update destroy]

  def index
    @q = current_corporation.corporate_admin_users.ransack(params[:q])
    @corporate_admin_users = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  def show; end

  def new
    @corporate_admin_user = current_corporation.corporate_admin_users.build
  end

  def edit; end

  def create
    @corporate_admin_user = current_corporation.corporate_admin_users.build(corporate_admin_user_params)
    if @corporate_admin_user.save
      redirect_to corporation_manage_corporate_admin_user_path(@corporate_admin_user), notice: t('common.messages.created', name: CorporateAdminUser.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @corporate_admin_user.update(corporate_admin_user_params)
      redirect_to corporation_manage_corporate_admin_user_path(@corporate_admin_user), notice: t('common.messages.updated', name: CorporateAdminUser.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @corporate_admin_user.destroy!
    redirect_to corporation_manage_corporate_admin_users_path, notice: t('common.messages.deleted', name: CorporateAdminUser.model_name.human)
  end

  private

  def set_corporate_admin_user
    @corporate_admin_user = current_corporation.corporate_admin_users.find(params[:id])
  end

  def corporate_admin_user_params
    params.require(:corporate_admin_user).permit(
      :email,
      :name,
      :tel,
      :password,
      :password_confirmation
    ).merge(advertise_notice_flag: false,
            user_type: :corporate_admin,
            payway: :invoice,
            state: :registered,
            corporation_ids: [current_corporation.id])
  end
end
