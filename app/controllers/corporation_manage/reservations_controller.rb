class CorporationManage::ReservationsController < CorporationManage::Base
  before_action :set_reservation, only: %i[show destroy edit update]

  def index
    @q = Reservation.with_corporation(current_corporation).ransack(params[:q])
    @reservations = @q.result.order(checkin: :desc)
    respond_to do |format|
      format.html do
        @reservations = @reservations.page(params[:page]).per(30)
      end
      format.csv do
        send_data @reservations.to_csv(col_sep: "\t"), filename: t('common.csv.reservation_csv', date: Time.zone.now.strftime('%Y/%m/%d'))
      end
    end
  end

  def show; end

  def new
    @reservation = if session[:reservation_attributes].present?
                     build_reservation_from_session
                   else
                     Reservation.new
                   end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    # TODO: 本当に条件これでいいのか確認する
    @reservation.reservation_user_id = @reservation.user_id
    @reservation.set_check_out
    @reservation.set_price
    if @reservation.valid?(:need_for_payment)
      session[:reservation_attributes] = @reservation.attributes
      render :confirm
    elsif @reservation.block_flag? && @reservation.save
      redirect_to corporation_manage_reservations_path, notice: t('common.messages.create_block', name: Reservation.model_name.human)
    else
      flash[:notice] = @reservation.errors[:price].first if @reservation.errors[:price].present?
      render :new
    end
  end

  def edit
  end

  def update
    if @reservation.update(reservation_note_params)
      redirect_to corporation_manage_reservation_path(@reservation), notice: t('common.messages.updated', name: Reservation.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # POST /corporation_manager/reservations/payments
  def payment
    build_reservation_from_session
    if @reservation.user.creditcard?
      @reservation.set_payment
      @reservation.save_and_charge!
    elsif @reservation.user.invoice?
      @reservation.save!
    end
    session[:reservation] = nil
    redirect_to corporation_manage_reservations_path, notice: t('common.messages.created', name: Reservation.model_name.human)
  rescue Stripe::StripeError => e
    logger.error("#{e.class.name} #{e.message}")
    flash[:notice] = t('errors.messages.stripe_error')
    render :confirm
  end

  def destroy
    ActiveRecord::Base.transaction do
      @reservation.destroy!
      NotificationMailer.reservation_canceled(@reservation, @reservation.user_id).deliver_now if @reservation.send_cc_mail?
      NotificationMailer.reservation_canceled(@reservation, @reservation.reservation_user_id).deliver_now
      NotificationMailer.reservation_canceled_to_admin(@reservation).deliver_now
    end
    redirect_to corporation_manage_reservations_path, notice: t('common.messages.deleted', name: Reservation.model_name.human)
  rescue
    redirect_to corporation_manage_reservations_path, alert: 'エラーが発生しました'
  end

  private

  def set_reservation
    @reservation = Reservation.with_corporation(current_corporation).find(params[:id])
  end

  def build_reservation_from_session
    @reservation = Reservation.new(session[:reservation_attributes])
  end

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

  def reservation_note_params
    params.require(:reservation).permit(:note)
  end
end
