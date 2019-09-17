class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :postal_matter_notification]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).personal.order(id: :desc).page(params[:page])
  end

  def new
    @user = @user_corp.present? ? @user_corp.users.new : User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
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

  def postal_matter_notification
    NotificationMailer.postal_matter_notification(@user).deliver_now
    flash[:notice] = "郵便物受け取りメールを送信しました"
    redirect_to @user.user_corp.present? ? admin_user_corp_path(@user.user_corp) : admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
    @user_corp = @user.user_corp
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :state,
      :payway, :parent_id, :advertise_notice_flag, :parent_id
    )
  end
end
