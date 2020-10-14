class CorporationManage::UsersController < CorporationManage::Base
  before_action :set_user, only: %i[show edit update destroy postal_matter_notification]

  def index
    @q = current_corporation.users.where(user_type: [User.user_types[:personal], User.user_types[:ks_flexible]]).ransack(params[:q])
    @users = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  def new
    @user = current_corporation.users.build
  end

  def create
    @user = current_corporation.users.build(user_params)
    if @user.save
      @user.related_corp_facilities! if current_corporation.facility_display_range_default == "related_corp_facilities"
      @user.skip_sms_verification_if_not_required!
      redirect_to corporation_manage_user_path(@user), notice: t('common.messages.created', name: User.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to corporation_manage_user_path(@user), notice: t('common.messages.updated', name: User.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to corporation_manage_users_path, notice: t('common.messages.deleted', name: User.model_name.human)
  end

  def postal_matter_notification
    NotificationMailer.postal_matter_notification(@user).deliver_now
    redirect_to corporation_manage_users_path, notice: '郵便物受け取りメールを送信しました'
  end

  private

  def set_user
    @user = current_corporation.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :parent_id,
      :password,
      :password_confirmation,
      :name,
      :tel,
      :state,
      :user_type,
      :payway,
      :facility_display_range,
    ).merge(corporation_ids: [current_corporation.id])
  end
end
