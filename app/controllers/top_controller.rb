class TopController < ApplicationController
  def index
    @shops = Shop.all.order(id: :desc)
    @information = Information.order(publish_time: :desc).limit(10)
  end

  def term_of_use; end

  def privacy_policy; end

  def special_commercial_code; end
end
