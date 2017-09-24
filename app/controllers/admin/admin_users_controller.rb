class Admin::AdminUsersController < AdminController
  before_action :set_admin_user, only: [:edit, :update, :destroy]

  # GET /admin/admin_users
  def index
    @admin_users = AdminUser.order(id: :desc).page(params[:page])
  end

  # GET /admin/admin_users/new
  def new
    @admin_user = AdminUser.new
  end

  # GET /admin/admin_users/1/edit
  def edit
  end

  # POST /admin/admin_users
  def create
    @admin_user = AdminUser.new(admin_user_params)

    if @admin_user.save
      redirect_to admin_admin_users_path, notice: '管理者を作成しました。'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/admin_users/1
  def update
    if @admin_user.update(admin_user_params)
      redirect_to admin_admin_users_path, notice: '管理者を更新しました'
    else
      render :edit
    end
  end

  # DELETE /admin/admin_users/1
  def destroy
    @admin_user.destroy
    redirect_to admin_admin_users_path, notice: '管理者を削除しました'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_user_params
    params.require(:admin_user).permit(:name, :email, :password, :password_confirmation, :deleted_at)
  end
end
