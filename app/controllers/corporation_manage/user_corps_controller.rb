class CorporationManage::UserCorpsController < CorporationManage::Base
  before_action :set_user_corp, only: %i[show edit update destroy]

  def index
    @q = current_corporation.users.parent_corporation.ransack(params[:q])
    @user_corps = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  def new
    @user_corp = current_corporation.users.build
  end

  def edit; end

  def create
    @user_corp = current_corporation.users.build(user_corp_params)
    if @user_corp.save
      redirect_to corporation_manage_user_corp_path(@user_corp), notice: "#{UserCorp.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def update
    if @user_corp.update(user_corp_params)
      redirect_to corporation_manage_user_corp_path(@user_corp), notice: "#{UserCorp.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @user_corp.destroy!
    redirect_to corporation_manage_user_corps_path, notice: "#{UserCorp.model_name.human}を削除しました。"
  end

  private

  def set_user_corp
    @user_corp = current_corporation.users.parent_corporation.find(params[:id])
  end

  def user_corp_params
    params.require(:user).permit(
      :email,
      :name,
      :tel,
      :max_user_num,
      :password,
      :password_confirmation
    ).merge(state: :registered,
            payway: :invoice,
            user_type: :parent_corporation,
            advertise_notice_flag: false,
            corporation_ids: [current_corporation.id])
  end
end
