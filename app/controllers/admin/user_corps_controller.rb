class Admin::UserCorpsController < AdminController
  before_action :set_user_corp, only: [:show, :edit, :update, :destroy]

  def index
    @q = UserCorp.ransack(params[:q])
    @user_corps = @q.result(distinct: true).parent_corporation.order(id: :desc).page(params[:page])
  end

  def new
    @user_corp = UserCorp.new
  end

  def edit; end

  def create
    @user_corp = UserCorp.new(user_corp_params)
    @user_corp.user_type = :personal
    if @user_corp.save!
      flash[:notice] = "#{UserCorp.model_name.human}を作成しました。"
      redirect_to admin_user_corp_path(@user_corp)
    else
      render :new
    end
  end

  def update
    if @user_corp.update(user_corp_params)
      flash[:notice] = "#{UserCorp.model_name.human}を更新しました。"
      redirect_to admin_user_corp_path(@user_corp)
    else
      render :edit
    end
  end

  def destroy
    @user_corp.destroy
    flash[:notice] = "#{UserCorp.model_name.human}を削除しました。"
    redirect_to admin_user_corps_path
  end

  private

  def set_user_corp
    @user_corp = UserCorp.find(params[:id])
  end

  def user_corp_params
    params.require(:user_corp).permit(
      :name, :tel, :state, :payway, :max_user_num
    )
  end
end
