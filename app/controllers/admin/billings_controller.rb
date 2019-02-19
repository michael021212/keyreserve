class Admin::BillingsController < AdminController

  def index
    set_month
    @billings = searched_billings.page(params[:page])
  end

  def show
    @billing = Billing.find(params[:id])
    @billing_details = @billing.reservations + @billing.dropin_reservations
  end

  private
  def set_month
    params[:month] = params[:month].presence || "#{Time.zone.now.last_month.year}/#{Time.zone.now.last_month.month}"
  end

  def searched_billings
    billings = Billing.where('year = ? && month = ?', params[:month].to_date.year, params[:month].to_date.month)
    return billings if params[:search].blank? || (params[:credit_card_include].present? && params[:invoice_include].present?)
    billings = billings.joins(:user).where.not(payment_way: Billing.payment_ways[:credit_card]) if params[:credit_card_include].blank?
    billings = billings.joins(:user).where.not(payment_way: Billing.payment_ways[:invoice]) if params[:invoice_include].blank?
    billings
  end
end
