class TopController < ApplicationController
  layout false
  skip_before_action :require_login

  def index
    if logged_in? && current_corporation.present?
      redirect_to corporations_dashboard_path
    elsif logged_in? && current_corporation.nil?
      redirect_to users_dashboard_path
    else
      flash[:alert] = '会員登録してください'
      redirect_to users_sign_in_path
    end
  end
end
