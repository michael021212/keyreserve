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

  def back_to_previous_form(e = nil)
    logger.warn '422 Invalid Access Token with exception occurred, and redirect to registration form:' + e.message + "\n" + e.backtrace.join("\n") if e
    redirect_back(fallback_location: sign_in_path, alert: 'エラーが発生しました。お手数ですが、もう一度お試しください')
  end
end
