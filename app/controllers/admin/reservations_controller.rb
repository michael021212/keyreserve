class Admin::ReservationsController < AdminController
  include ApplicationHelper

  def index
    @reservations = Reservation.all.order(id: :desc).page(params[:page])
    q = params[:q] || {}
    @q = Reservation.ransack(q)
    @reservations = @q.result
    respond_to do |format|
      format.html do
        @reservations = @reservations.page(params[:page]).per(30)
      end
      format.csv do
        send_data @reservations.to_csv(col_sep: "\t"), filename: "reservations_#{csv_datetime}.csv"
      end
    end
  end
end
