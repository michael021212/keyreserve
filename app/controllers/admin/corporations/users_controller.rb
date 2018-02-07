class Admin::Corporations::UsersController < AdminController
  before_action :set_corporation, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
    @user.corporation_users.build
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "#{User.model_name.human}を作成しました。"
      redirect_to admin_corporation_path(@corporation)
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "#{User.model_name.human}を更新しました。"
      redirect_to admin_corporation_user_path(@corporation, @user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "#{User.model_name.human}を削除しました。"
    redirect_to admin_corporation_path(params[:corporation_id])
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :tel, :state, :payway,
      corporation_users_attributes: [:id, :corporation_id]
    )
  end
end
