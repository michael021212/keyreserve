class TopController < ApplicationController
  def index
    @shops = Shop.order(id: :desc).page(params[:page])
  end
end
