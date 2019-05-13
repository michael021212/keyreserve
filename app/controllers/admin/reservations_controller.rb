class Admin::ReservationsController < AdminController
  include ApplicationHelper
  before_action :set_reservation, only: [:show, :destroy]
  before_action :set_reservation_from_session, only: [:payment, :confirm]

  def index
    q = params[:q] || {}
    @q = Reservation.ransack(q)
    @reservations = @q.result.order(checkin: :desc)
    respond_to do |format|
      format.html do
        @reservations = @reservations.page(params[:page]).per(30)
      end
      format.csv do
        send_data @reservations.to_csv(col_sep: "\t"), filename: "reservations_#{csv_datetime}.csv"
      end
    end
  end

  def show; end

  def new
    @reservation = if session[:reservation].present?
                     Reservation.new(session[:reservation])
                   else
                     Reservation.new
                   end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = nil if  @reservation.block_flag?
    if @reservation.usage_period.blank?
      flash[:error] = '利用時間を入力してください'
      return render :new
    end
    @reservation.checkout = @reservation.checkin + @reservation.usage_period.hours
    if @reservation.facility.reservations.in_range(@reservation.checkin .. @reservation.checkout).present?
      flash[:error] = 'この時間帯の予約が既にあるので、重複の予約はできません'
      return render :new
    end
    if  @reservation.block_flag == 'true' || reservation_params[:user_id].nil?
      @reservation.user_id = nil
      @reservation.reservation_user_id = nil
    else
      @reservation.reservation_user_id = @reservation.user_id
      user = User.find(@reservation.user_id)
      user = user.user_corp.present? ? user.user_corp : user
      @reservation.user_id = user.id
    end
    @reservation.state = :confirmed
    price = @reservation.facility.calc_price(@reservation.user, @reservation.checkin, @reservation.usage_period)
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
      flash[:error] = 'ご利用者のクレジットカード情報がまだ登録されていません'
      return render :payment
    end
    if @reservation.user.creditcard? && @reservation.price <= 50
      flash[:error] = 'クレジットカードで決済する場合は、利用料金が50円を超えるようにしてください'
      return render :payment
    end
    @reservation.set_payment
    @reservation.payment.stripe_charge!
    if @reservation.save
      session[:reservation] = nil
      NotificationMailer.reserved(@reservation, @reservation.reservation_user_id).deliver_now
      NotificationMailer.reserved(@reservation, @reservation.user_id).deliver_now if @reservation.send_cc_mail?
      NotificationMailer.reserved_to_admin(@reservation).deliver_now
      redirect_to admin_reservations_path, notice: "#{Reservation.model_name.human}を作成しました。"
    else
      flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
      render :new
    end
  end

  def destroy
    @reservation.destroy
    redirect_to admin_reservations_path, notice: '予約を削除しました'
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_reservation_from_session
    @reservation = Reservation.new(session[:reservation])
  end

  def reservation_params
    params.require(:reservation).permit(
      :facility_id, :user_id, :reservation_user_id, :num, :checkin, :usage_period, :state, :block_flag
    )
  end
end
