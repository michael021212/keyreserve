class CorporationManage::Base < ApplicationController
  class AuthenticateCorporationError < StandardError; end
  layout 'corporation_manage/layouts/application'
  before_action :authenticate_corporation!

  rescue_from AuthenticateCorporationError, with: :corporation_not_authorized

  private

  def authenticate_corporation!
    raise AuthenticateCorporationError unless current_corporation?
  end

  def corporation_not_authorized
    redirect_to root_path, notice: 'アクセスできません'
  end
end
