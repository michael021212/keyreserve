class TopController < ApplicationController
  layout false
  # skip_before_filter :require_login, :check_creditcard

  def index
    if logged_in?
      redirect_to users_path
    end
  end
end
