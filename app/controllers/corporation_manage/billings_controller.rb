class CorporationManage::BillingsController < CorporationManage::Base

  def index
    set_default_year_month if params[:q].nil?
    @q = Billing.target_shops(current_corporation.shops.ids).ransack(params[:q])
    @billings = @q.result(distinct: true).page(params[:page])
  end

  def show
    @billing = Billing.find(params[:id])
    @billing_details = @billing.reservations.push(@billing.dropin_reservations)
  end

  private

  def set_default_year_month
    params[:q] = { year_month_eq: "#{Time.zone.now.last_month.year}/#{Time.zone.now.last_month.month}" }
  end
end
