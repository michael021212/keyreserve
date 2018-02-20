class TopController < ApplicationController
  layout false
  # skip_before_filter :require_login, :check_creditcard

  def index
    if logged_in?
      redirect_to dashboard_path
    else
      flash[:alert] = '会員登録してください'
      redirect_to users_sign_in_path
    end
  end
end
