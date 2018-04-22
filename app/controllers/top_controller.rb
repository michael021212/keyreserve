class TopController < ApplicationController
  def index
    @shops = Shop.order(id: :desc)
    @information = Information.order(publish_time: :desc).limit(10)
  end
end
