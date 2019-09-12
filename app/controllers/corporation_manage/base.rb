class CorporationManage::Base < ApplicationController
  class AuthenticateCorporationError < StandardError; end
  layout 'corporation_manage/layouts/application'
  before_action :authenticate_corporation!

  rescue_from AuthenticateCorporationError, with: :corporation_not_authorized
  rescue_from ActiveRecord::DeleteRestrictionError, with: :can_not_delete

  private

  def authenticate_corporation!
    raise AuthenticateCorporationError unless current_user.present? && current_user.corporate_admin? && current_corporation?
  end

  def corporation_not_authorized
    redirect_to root_path, notice: 'アクセスできません'
  end
  
  def can_not_delete
    redirect_back fallback_location: root_path, notice: t('errors.messages.restrict_dependent_destroy.has_many')
  end
end
