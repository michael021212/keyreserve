class Admin::CorporationUsersController < AdminController
  before_action :set_corporation
  before_action :set_corporation_user, only: [:show, :edit, :update, :destroy]

  def index
    @corporation_users = @corporation.corporation_users.order(id: :desc).page(params[:page])
  end

  def new
    @corporation_user = @corporation.corporation_users.new
    @corporation_user.build_user
  end

  def create
    @corporation_user = @corporation.corporation_users.new(corporation_user_params)
    if @corporation_user.save
      redirect_to [:admin, @corporation, @corporation_user], notice: "#{CorporationUser.model_name.human}を作成しました。"
    else
      render :new
    end 
  end

  def show; end
  
  def edit; end

  def update
    @corporation_user.assign_attributes(corporation_user_params)
    if @corporation_user.update(corporation_user_params)
      redirect_to [:admin, @corporation, @corporation_user], notice: "#{CorporationUser.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @corporation_user.destroy
    redirect_to admin_corporation_path(@corporation)
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_corporation_user
    @corporation_user = @corporation.corporation_users.find(params[:id])
  end

  def corporation_user_params
    params.require(:corporation_user).permit(
      user_attributes: [:id, :email, :password, :password_confirmation, :name, :tel, :state, :payway]
    )
  end
end
