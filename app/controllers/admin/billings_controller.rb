class Admin::BillingsController < AdminController

  def index
    @billings = Billing.all.page(params[:page])
  end

  def show
    @billing = Billing.find(params[:id])
    @billing_details = @billing.reservations + @billing.dropin_reservations
  end
end
