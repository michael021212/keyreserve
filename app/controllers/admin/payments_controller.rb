class Admin::PaymentsController < AdminController
  before_action :set_payment, only: [:show]

  # GET /admin/payments
  def index
    @payments = Payment.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end
end
