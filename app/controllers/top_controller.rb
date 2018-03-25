class TopController < ApplicationController
  def index
    @shops = Shop.order(id: :desc)
    @information = Information.order(created_at: :desc).limit(10)
  end
end
