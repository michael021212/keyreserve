class TopController < ApplicationController
  def index
    @shops = Shop.where.not(is_rent: true).order(id: :desc)
    @information = Information.order(publish_time: :desc).limit(10)
  end

  def term_of_use; end

  def privacy_policy; end
end
