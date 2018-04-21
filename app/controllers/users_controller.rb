class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def new
    logout if logged_in?
    @user = User.new
    session[:parent_token] = params[:parent_token]

  end

  def create
    @user = User.new(user_params)
    if session[:parent_token].present?
      user_corp ||= UserCorp.find_by(parent_token: session[:parent_token])
      @user.parent_id = user_corp.id if user_corp.present?
    end
    if @user.save
      session[:parent_token] = nil
      respond_to do |format|
        format.html do
          auto_login(@user)
          redirect_to root_path, notice: "#{User.model_name.human}を作成しました。"
        end
      end
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: 'アカウント情報を更新しました'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :tel, :state, :payway, :user_type, :parent_id,
      :advertise_notice_flag
    )
  end
end
