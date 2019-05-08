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

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.set_check_out
    if @reservation.save
      redirect_to corporation_manage_reservations_path, notice: "#{Reservation.model_name.human}ブロックを作成しました。"
    else
      render :new
    end
  end
  
  private

  def reservation_params
    params.require(:reservation).permit(
      :facility_id,
      :user_id,
      :num,
      :checkin,
      :usage_period,
      :state,
      :block_flag
    ).merge(state: :confirmed)
  end
end
