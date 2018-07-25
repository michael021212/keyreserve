class Admin::DropinReservationsController < AdminController
  include ApplicationHelper

  def index
    q = params[:q] || {}
    @q = DropinReservation.ransack(q)
    @dropin_reservations = @q.result.order(checkin: :desc)
    respond_to do |format|
      format.html do
        @dropin_reservations = @dropin_reservations.page(params[:page]).per(30)
      end
      format.csv do
        send_data @dropin_reservations.to_csv(col_sep: "\t"), filename: "dropin_reservations_#{csv_datetime}.csv"
      end
    end
  end

  def show
    @dropin_reservation = DropinReservation.find(params[:id])
  end

  private

end
