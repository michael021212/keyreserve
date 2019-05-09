class CorporationManage::UsersController < CorporationManage::Base
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = current_corporation.users.order(id: :desc).page(params[:page])
  end

  def new
    @user = current_corporation.users.build
  end

  def create
    @user = current_corporation.users.build(user_params)
    if @user.save
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
      :payway
    ).merge(corporation_ids: [current_corporation.id])
  end
end
