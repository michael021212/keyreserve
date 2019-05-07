class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_personal_identification, only: [:show]

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
    ActiveRecord::Base.transaction do
      @user.corporation_users.build(corporation_id: user_params[:corporation_id]) if user_params[:corporation_id].present?
      @user.save!
      @user.invoice! if @user.campaign_id.present?
      if @user.campaign_id.present?
        NotificationMailer.campaign_user_registration(@user).deliver_now
        NotificationMailer.campaign_user_registration_to_admin(@user).deliver_now
      end
    end
    session[:parent_token] = nil
    respond_to do |format|
      format.html do
        auto_login(@user)
        target = session[:return_to_url].present? ? session[:return_to_url] : root_url
        session[:return_to_url] = nil
        redirect_to target, notice: "#{User.model_name.human}を作成しました。"
      end
    end
  rescue => e
    logger.debug(e)
    render :new
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

  def set_personal_identification
    @personal_identification = @user.personal_identification
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :tel, :state, :payway, :user_type, :parent_id,
      :advertise_notice_flag, :stripe_customer_id, :campaign_id, :corporation_id
    )
  end
end
