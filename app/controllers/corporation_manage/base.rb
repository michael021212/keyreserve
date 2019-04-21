class CorporationManage::Base < ApplicationController
  layout 'corporation_manage/layouts/application'
  before_action :authenticate_corporation!

  rescue_from Corporation::AuthenticateError, with: :corporation_not_authorized

  private

  def authenticate_corporation!
    raise Corporation::AuthenticateError unless current_corporation?
  end

  def corporation_not_authorized
    redirect_to root_path, notice: 'アクセスできません'
  end
end
