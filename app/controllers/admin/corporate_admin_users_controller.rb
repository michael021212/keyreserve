class Admin::CorporateAdminUsersController < AdminController
  before_action :set_corporation
  before_action :set_corporate_admin_user, only: [:show, :edit, :update, :destroy]

  def index
    @corporate_admin_users = @corporation.corporate_admin_users.order(id: :desc).page(params[:page])
  end

  def new
    @corporate_admin_user = @corporation.corporate_admin_users.new
  end

  def create
    @corporate_admin_user = @corporation.corporate_admin_users.new(corporate_admin_user_params)
    @corporate_admin_user.corporation_users.build(corporation_id: @corporation.id)
    if @corporate_admin_user.save
      redirect_to [:admin, @corporation, @corporate_admin_user], notice: "#{CorporateAdminUser.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    @corporate_admin_user.assign_attributes(corporate_admin_user_params)
    if @corporate_admin_user.update(corporate_admin_user_params)
      redirect_to [:admin, @corporation, @corporate_admin_user], notice: "#{CorporateAdminUser.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @corporate_admin_user.destroy
    redirect_to admin_corporation_corporate_admin_users_path(@corporation), notice: "#{CorporationUser.model_name.human}を削除しました。"
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:corporation_id])
  end

  def set_corporate_admin_user
    @corporate_admin_user = @corporation.corporate_admin_users.find(params[:id])
  end

  def corporate_admin_user_params
    params.require(:corporate_admin_user).permit(
                        :id,
                        :email,
                        :password,
                        :password_confirmation,
                        :name,
                        :tel,
                        :state,
                        :payway
    ).to_h.deep_merge({ user_type: :corporate_admin })
  end
end
