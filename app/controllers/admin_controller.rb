class AdminController < ActionController::Base
  before_action :better_errors_hack, if: -> { Rails.env.development? }
  protect_from_forgery with: :exception
  layout 'admin/layouts/application'

  before_action :authenticate_admin_user!
  
  rescue_from ActiveRecord::DeleteRestrictionError, with: :can_not_delete

  def current_admin_user
    if session[:admin_user_id].present?
      @current_admin_user ||= AdminUser.find(session[:admin_user_id])
    end
  end
  helper_method :current_admin_user

  private

  def authenticate_admin_user!
    if session[:admin_user_id].nil?
      redirect_to admin_sign_in_path, notice: 'ログインが必要です。'
    end
  end

  def better_errors_hack
    request.env['puma.config'].options.user_options.delete(:app) if request.env.has_key?('puma.config')
  end

  def can_not_delete
    redirect_back fallback_location: root_path, notice: t('errors.messages.restrict_dependent_destroy.has_many')
  end
end
