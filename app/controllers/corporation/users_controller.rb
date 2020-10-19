class Corporation::UsersController < ApplicationController
  before_action :set_corporation_from_token

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.corporation_users.new(corporation_id: @corporation.id)
    if @user.save(context: :new_user_registration)
      @user.related_corp_facilities! if current_corporation.related_corp_facilities?
      @user.reload
      @user.skip_sms_verification_if_not_required!
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

  private
  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :tel,
      :state,
      :payway,
      :user_type,
      :parent_id,
      :advertise_notice_flag,
      :stripe_customer_id,
      :campaign_id,
      :corporation_id,
      :term_of_use,
    )
  end

  def set_corporation_from_token
    @corporation = Corporation.find_by(corporation_token: params[:corporation_token])
    redirect_to root_path, notice: 'URLが不正です' if @corporation.blank?
  end
end
