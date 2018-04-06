class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "#{User.model_name.human}を作成しました。"
      redirect_to admin_user_path(@user)
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "#{User.model_name.human}を更新しました。"
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "#{User.model_name.human}を削除しました。"
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :tel, :state, :payway, :advertise_notice_flag
    )
  end
end
