class Users::ApplicationController < ApplicationController
  layout 'users/layouts/application'
  before_action :require_login, :current_corporation
  helper_method :current_corporation

  def current_corporation
    if current_user.try(:corporations)
      current_user.corporations.first
    end
  end
end
