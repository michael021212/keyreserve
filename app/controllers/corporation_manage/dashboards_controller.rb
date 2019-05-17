class CorporationManage::DashboardsController < CorporationManage::Base
  def index
    @shops = current_corporation.shops.order(id: :desc).page(params[:page])
  end
end
