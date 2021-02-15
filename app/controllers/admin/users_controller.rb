class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :proxy_access]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).where.not(user_type: :parent_corporation).order(id: :desc).page(params[:page])
  end

  def new
    @user = @user_corp.present? ? @user_corp.users.new : User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.skip_sms_verification_if_not_required!
      flash[:notice] = "#{User.model_name.human}を作成しました。"
      redirect_to @user.user_corp.present? ? [:admin, @user.user_corp, @user] : [:admin, @user]
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "#{User.model_name.human}を更新しました。"
      redirect_to @user.user_corp.present? ? [:admin, @user.user_corp, @user] : [:admin, @user]
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "#{User.model_name.human}を削除しました。"
    redirect_to @user.user_corp.present? ? admin_user_corp_path(@user.user_corp) : admin_users_path
  end

  def proxy_access
    auto_login(@user)
    session[:user_id] = @user.id
    redirect_to root_path, notice: "#{@user.name}アカウントで代理ログインしました"
  end

  private

  def set_user
    @user = User.find(params[:id])
    @user_corp = @user.user_corp
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :state, :user_type,
      :payway, :parent_id, :advertise_notice_flag, :parent_id, :browsable_range, corporation_ids: []
    )
  end
end
