class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_corporation

  # GET /admin/users
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  # GET /admin/users/new
  def new
    @user = User.new
    @user.corporation_users.new(corporation_id: params[:corporation_id]) if corporation?
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)
    if corporation?
      @user.payway = :creditcard
      @user.state = :registered
    end
    if @user.save!
      flash[:notice] = "#{User.model_name.human}を作成しました。"
      if corporation?
        redirect_to [:admin, @corporation, @user]
      else
        redirect_to [:admin, @user]
      end
    else
      render :new
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    if @user.update(user_params)
      flash[:notice] = "#{User.model_name.human}を更新しました。"
      if corporation?
        redirect_to [:admin, @corporation, @user]
      else
        redirect_to [:admin, @user]
      end
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy
    flash[:notice] = "#{User.model_name.human}を削除しました。"
    if corporation?
      redirect_to [:admin, @corporation]
    else
      redirect_to admin_users_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
      :corporation_id, :email, :password, :password_confirmation, :name, :tel, :state, :payway,
      corporation_users_attributes: [:id, :corporation_id, :_destroy]
    )
  end

  def corporation?
    params[:corporation_id].present?
  end

  def set_corporation
    if corporation?
      @corporation = Corporation.find(params[:corporation_id])
    end
  end

  helper_method :corporation?
end
