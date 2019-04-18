class Corporation::Base < ApplicationController
  class AuthenticateCoroporationError < StandardError; end
  layout 'corporation/layouts/application'
  before_action :authenticate_corporation!

  rescue_from AuthenticateCoroporationError, with: :corporation_not_authorized

  private

  def authenticate_corporation!
    raise AuthenticateCoroporationError unless current_corporation?
  end

  def corporation_not_authorized
    redirect_to root_path, notice: 'アクセスできません'
  end
end
