class Admin::ReservationsController < AdminController
  include ApplicationHelper
  before_action :set_reservation, only: [:payment, :confirm]

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
    @reservation = if session[:reservation].present?
                     Reservation.new(session[:reservation])
                   else
                     Reservation.new
                   end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.checkin > @reservation.checkout
      flash[:error] = '利用開始時間が利用終了時間を越しています'
      return render :new
    end
    if @reservation.facility.reservations.in_range(@reservation.checkin .. @reservation.checkout).present?
      flash[:error] = 'この時間帯のご予約はありましたので、重複のご予約はできません'
      return render :new
    end
    usage_period = ((@reservation.checkout - @reservation.checkin) / 3600).ceil
    if  @reservation.block_flag == 'true' || reservation_params[:user_id].nil?
      @reservation.user_id = nil
    else
      user = User.find(reservation_params[:user_id])
      user = user.user_corp.present? ? user.user_corp : user
      @reservation.user_id = user.id
    end
    price = @reservation.facility.calc_price(@reservation.user, @reservation.checkin, usage_period)
    @reservation.usage_period = usage_period
    @reservation.state = :confirmed
    @reservation.price = price if @reservation.user_id?
    session[:reservation] = @reservation if @reservation.user_id?
    if @reservation.user_id?
      redirect_to payment_admin_reservations_path
    else
      if @reservation.save
        redirect_to admin_reservations_path, notice: "#{Reservation.model_name.human}ブロックを作成しました。"
      else
        render :new
      end
    end
  end

  def payment; end

  def confirm
    if @reservation.user.credit_card.blank? && @reservation.user.creditcard?
      flash[:error] = 'ご利用者のクレジットカード情報はまだ登録いたしません'
      return render :payment
    end
    if @reservation.user.creditcard? && @reservation.price <= 50
      flash[:error] = 'クレジットカードで決済する場合に、利用料金は50円以上を超えてください'
      return render :payment
    end
    if @reservation.save
      session[:reservation] = nil
      NotificationMailer.reserved(@reservation).deliver_now
      NotificationMailer.reserved_to_admin(@reservation).deliver_now
      redirect_to admin_reservations_path
    else
      flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
      render :new
    end
  end

  private

  def set_reservation
    @reservation = Reservation.new(session[:reservation])
  end

  def reservation_params
    params.require(:reservation).permit(
      :facility_id, :user_id, :num, :checkin, :checkout, :state, :block_flag
    )
  end
end
