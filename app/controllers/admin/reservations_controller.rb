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
    if @reservation.checkin > @reservation.checkout
      flash[:error] = '利用開始時間が利用終了時間を越しています'
      return render :new
    end
    if @reservation.facility.reservations.in_range(@reservation.checkin .. @reservation.checkout).present?
      flash[:error] = 'この時間帯のご予約はできません'
      return render :new
    end
    usage_period = ((@reservation.checkout - @reservation.checkin) / 3600).to_i
    @reservation.usage_period = usage_period
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
      :facility_id, :user_id, :checkin, :checkout, :state
    )
  end
end
