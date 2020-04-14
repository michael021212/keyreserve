class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :tel, :sms, :sms_confirm]
  before_action :set_personal_identification, only: [:show]
  before_action :require_login, except: [:new, :create]
  before_action :require_sms_verification, except: [:new, :create, :tel, :sms, :sms_confirm]
  rescue_from ActionController::InvalidAuthenticityToken, with: :back_to_previous_form

  def new
    set_facility_from_return_to_url
    logout if logged_in?
    @user = User.new
    session[:parent_token] = params[:parent_token]
  end

  def create
    set_facility_from_return_to_url
    @user = User.new(user_params)
    @user.payway = :invoice if @facility.present? && @facility.rent?
    @user.corporation_users.build(corporation_id: user_params[:corporation_id]) if user_params[:corporation_id].present?
    if session[:parent_token].present?
      user_corp ||= UserCorp.find_by(parent_token: session[:parent_token])
      @user.parent_id = user_corp.id if user_corp.present?
    end
    if @user.save(context: :new_user_registration)
      @user.reload
      @user.skip_sms_verification_if_not_required!
      session[:parent_token] = nil
      auto_login(@user)
      if @user.sms_verified
        redirect_to root_path, notice: 'ユーザ登録が完了しました'
      else
        redirect_to tel_user_path
      end
    else
      render :new
    end
  end

  # 電話番号入力
  def tel; end

  # 認証コード送信画面
  def sms
    tel = set_international_phone_number
    verify_code = SecureRandom.random_number(100000)
    res = TwilioApi.send_sms(tel, verify_code)
    if tel.present? && res.present?
      @user.update(tel: tel, sms_verify_code: verify_code, sms_sent_at: Time.zone.now)
    else
      flash.now[:alert] = '電話番号が確認できませんでした。'
      render :tel
    end
  end


  # 認証コードの確認
  def sms_confirm
    if @user.sms_verify_code.to_s == params[:sms_verify_code]
      ActiveRecord::Base.transaction do
        @user.update!(sms_verified: true)
        @user.invoice! if @user.campaign_id.present?
        if @user.campaign_id.present?
          NotificationMailer.campaign_user_registration(@user).deliver_now
          NotificationMailer.campaign_user_registration_to_admin(@user).deliver_now
        end
      end
      respond_to do |format|
        format.html do
          target = session[:return_to_url].present? ? session[:return_to_url] : root_url
          redirect_to target, notice: "#{User.model_name.human}登録が完了しました"
        end
      end
    else
      flash.now[:alert] = '認証コードが正しくありません'
      render :sms
    end
  rescue => e
    logger.debug(e)
    flash.now[:alert] = 'エラーが発生しました。お手数ですがもう一度お試しください。'
    render :send_sms
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

  def set_international_phone_number
    tel = Phonelib.parse(params[:user][:tel], :jp)
    tel.valid? ? "+#{tel.international(false)}" : ''
  end

  def set_user
    @user = current_user
  end

  def set_personal_identification
    @personal_identification = @user.present? ? @user.personal_identification : nil
  end

  def user_tel_params
    params.require(:user).permit(:tel)
  end

  def user_verify_code_params
    params.require(:user).permit(:verify_code)
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :tel, :state, :payway, :user_type, :parent_id,
      :advertise_notice_flag, :stripe_customer_id, :campaign_id, :corporation_id, :term_of_use
    )
  end

  def set_facility_from_return_to_url
    return_to_url = session[:return_to_url].present? ? session[:return_to_url].match(/shops\/\d+\/facilities\/new\?id=(\d+)/) : nil
    facility_id = return_to_url[1] if return_to_url.present?
    @facility = Facility.find_by(id: facility_id) if facility_id.present?
  end
end
