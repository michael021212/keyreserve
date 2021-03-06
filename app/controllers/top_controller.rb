class TopController < ApplicationController
  before_action :set_user

  def index
    @shops = Shop.available_shops(@user).order(id: :desc)
    @information = Information.order(publish_time: :desc).limit(10)
  end

  def term_of_use; end

  def privacy_policy; end

  def special_commercial_code; end
end
private

def set_user
  @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
end
