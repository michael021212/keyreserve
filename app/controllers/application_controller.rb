class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_corporation, :current_corporation?, :current_user_corp

  def current_corporation
    current_user.corporations.first if current_user.try(:corporations)
  end

  def current_corporation?
    current_corporation.present?
  end

  def current_user_corp
    current_user_corp ||= current_user.user_corp
  end
end
