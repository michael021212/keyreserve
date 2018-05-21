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

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = nil if  @reservation.block_flag?
    @reservation.checkout = @reservation.checkin + @reservation.usage_period.hours
    if @reservation.facility.reservations.in_range(@reservation.checkin .. @reservation.checkout).present?
      flash[:error] = 'この時間帯のご予約はできません'
      return render :new
    end
    @reservation.state = :confirmed
    if @reservation.save
      redirect_to admin_reservations_path, notice: "#{Reservation.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :facility_id, :user_id, :checkin, :usage_period, :state, :block_flag
    )
  end
end
