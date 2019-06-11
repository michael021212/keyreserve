class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_corporation, :current_corporation?, :current_user_corp

  def require_sms_verification
    redirect_to tel_user_path, alert: '電話番号による本人確認を実施してください'  unless current_user.sms_verified
  end

  def current_corporation
    current_user.corporations.first if current_user.try(:corporations)
  end

  def current_corporation?
    current_corporation.present?
  end

  def current_user_corp
    current_user_corp ||= current_user.user_corp
  end

  def not_authenticated
    redirect_to new_session_url
  end
end
