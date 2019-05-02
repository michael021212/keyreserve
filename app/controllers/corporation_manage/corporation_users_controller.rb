class CorporationManage::CorporationUsersController < CorporationManage::Base
  before_action :set_corporation_user, only: %i[show edit update destroy]

  def index
    @corporation_users = current_corporation.corporation_users.order(id: :desc).page(params[:page])
  end

  def new
    @corporation_user = current_corporation.corporation_users.build
    @corporation_user.build_user
  end

  def create
    @corporation_user = current_corporation.corporation_users.build(corporation_user_params)
    if @corporation_user.save
      redirect_to corporation_manage_corporation_user_path(@corporation_user), notice: "#{User.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def show
    @user = @corporation_user.user
  end

  def edit; end

  def update
    if @corporation_user.update(corporation_user_params)
      redirect_to corporation_manage_corporation_user_path(@corporation_user), notice: "#{User.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @corporation_user.destroy!
    redirect_to corporation_manage_corporation_users_path, notice: "#{User.model_name.human}を削除しました。"
  end

  private

  def set_corporation_user
    @corporation_user = current_corporation.corporation_users.find(params[:id])
  end

  def corporation_user_params
    params.require(:corporation_user).permit(
      user_attributes: [
        :id,
        :email,
        :password,
        :password_confirmation,
        :name,
        :tel,
        :state,
        :payway
      ]
    )
  end
end
