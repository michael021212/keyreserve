class CorporationManage::DropinReservationsController < CorporationManage::Base
  def index
    @q = DropinReservation.with_corporation(current_corporation).ransack(params[:q])
    @dropin_reservations = @q.result.order(checkin: :desc)
    respond_to do |format|
      format.html do
        @dropin_reservations = @dropin_reservations.page(params[:page]).per(30)
      end
      format.csv do
        send_data @dropin_reservations.to_csv(col_sep: "\t"), filename: t('common.csv.dropin_reservation_csv', date: Time.zone.now.strftime('%Y/%m/%d'))
      end
    end
  end
  
  def show
    @dropin_reservation = DropinReservation.find(params[:id])
  end
end
