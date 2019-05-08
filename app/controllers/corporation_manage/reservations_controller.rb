class CorporationManage::ReservationsController < CorporationManage::Base
  def index
    @q = Reservation.ransack(params[:q])
    @reservations = @q.result.order(checkin: :desc)
    respond_to do |format|
      format.html do
        @reservations = @reservations.page(params[:page]).per(30)
      end
    end
  end
end
