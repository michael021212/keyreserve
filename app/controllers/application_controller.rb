class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login, :current_corporation
  helper_method :current_corporation, :current_corporation?
  layout :set_layout

  def current_corporation
    current_user.corporations.first if current_user.try(:corporations)
  end

  def current_corporation?
    current_corporation.present?
  end

  def set_layout
    current_corporation.present? ? 'corporations/layouts/application' : 'users/layouts/application'
  end
end
