class Admin::AdminUsersController < AdminController
  before_action :set_admin_user, only: [:edit, :update, :destroy]

  def index
    @admin_users = AdminUser.order(id: :desc).page(params[:page])
  end

  def new
    @admin_user = AdminUser.new
  end

  def edit; end

  def create
    @admin_user = AdminUser.new(admin_user_params)

    if @admin_user.save
      redirect_to admin_admin_users_path, notice: '管理者を作成しました。'
    else
      render :new
    end
  end

  def update
    if @admin_user.update(admin_user_params)
      redirect_to admin_admin_users_path, notice: '管理者を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @admin_user.destroy
    redirect_to admin_admin_users_path, notice: '管理者を削除しました'
  end

  private

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.require(:admin_user).permit(:name, :email, :password, :password_confirmation, :deleted_at)
  end
end
