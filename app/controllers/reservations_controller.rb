class ReservationsController <  ApplicationController
  before_action :set_user
  before_action :require_login, except: [:spot]
  include ActionView::Helpers::NumberHelper
  include SearchParams

  def index
    @reservations = @user.reservations.order(checkin: :desc)
  end

  def show
    @reservation = @user.reservations.find(params[:id])
  end

  # 検索ページ
  def spot
    @condition = params[:spot] ||= {}
    return render :spot if @condition.blank?
    return render :spot unless valid_search_params?(@condition) #@checkinと@checkoutもset
    @facilities = Facility.reservable_facilities(@checkin, @checkout, @condition, current_user)
    return render :spot if @facilities.blank?
    @facilities = Facility.order_by_min_price(@facilities, current_user).page(params[:page])
    session[:spot] = @condition
  end

  # 1.ご利用情報入力
  def new
    @condition = params[:spot] ||= session[:spot].map{|k,v| [k.to_sym,v]}.to_h
    session[:reservation_id] = nil
    @facility = @user.login_spots.find_by(id: params[:facility_id])
    if @facility.blank?
      flash[:error] = '検索条件を入力してください'
      redirect_to spot_reservations_path
    end
  end

  # 利用料金の計算用
  def price
    @condition = params[:spot]
    @facility = @user.login_spots.find_by(id: @condition[:facility_id]) if @condition[:facility_id].present?
    return render json: { price: '' } if empty_params?(@condition)
    set_checkin(@condition)
    price = @facility.calc_price(@user, @checkin, @condition[:use_hour].to_f)
    render json: { price: number_with_delimiter(price) }
  end

  # クレカ情報登録処理
  def credit_card
    @condition = session[:spot].map{|k,v| [k.to_sym,v]}.to_h
    set_selected_facility(@condition)
    return redirect_to confirm_reservations_url if current_user.credit_card.present?
    @credit_card = @user.build_credit_card(credit_card_params)
    return render :credit_card unless @credit_card.valid?
    begin
      @credit_card.save!
      current_user.activated!
      redirect_to confirm_reservations_url
    rescue => e
      logger.warn("#{e.class.name} #{e.message}")
      flash[:error] = 'クレジットカードの登録に失敗しました。入力情報が正しいか、今一度ご確認ください。'
      render :credit_card
    end
  end

  # 2.カード情報入力
  # 3.確認画面
  def confirm
    @condition = params[:page] == 'shop' ? session[:spot].map{|k,v| [k.to_sym,v]}.to_h : (params[:spot] ||= {})
    session[:spot] = @condition if @condition.present?
    set_selected_facility(@condition)

    # 施設未選択なら検索フォームにリダイレクト
    if @facility.blank?
      flash[:error] = '施設を選択してください'
      redirect_to spot_reservations_path and return
    end

    # 検索クエリが正常かどうかチェック
    return render :new unless valid_search_params?(@condition)

    # 店舗の運営時間外の予約ならエラー
    if @facility.shop.out_of_business_time?(@checkin, @checkout)
      flash[:error] = 'ご予約時間が営業時間外となります'
      return render :new
    end

    @price = @facility.calc_price(@user, @checkin, @condition[:use_hour].to_f)
    # クレカ払い & クレカの登録がない場合は登録画面に遷移
    if @user.credit_card.blank? && @user.creditcard?
      @credit_card = current_user.build_credit_card
      return render :credit_card
    end
  end

  def create
    @condition = session[:spot] ||= {}
    if @condition.blank?
      flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
      redirect_to spot_reservations_url and return
    end
    @reservation = Reservation.new_from_spot(@condition, @user, current_user)
    @reservation.set_payment
    ActiveRecord::Base.transaction do
      @reservation.payment.stripe_charge
      @reservation.save!
      session[:spot] = nil
      session[:reservation_id] = @reservation.id
      NotificationMailer.reserved(@reservation, @reservation.user_id).deliver_now if @reservation.send_cc_mail?
      NotificationMailer.reserved(@reservation, @reservation.reservation_user_id).deliver_now
      NotificationMailer.reserved_to_admin(@reservation).deliver_now
    end
      redirect_to thanks_reservations_url
  rescue => e
    logger.debug(e)
    flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
    redirect_to spot_reservations_url
  end

  def thanks
    @reservation = Reservation.find(session[:reservation_id])
    @facility = @reservation.facility
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    ActiveRecord::Base.transaction do
      @reservation.destroy!
      NotificationMailer.reservation_canceled(@reservation, @reservation.user_id).deliver_now if @reservation.send_cc_mail?
      NotificationMailer.reservation_canceled(@reservation, @reservation.reservation_user_id).deliver_now
      NotificationMailer.reservation_canceled_to_admin(@reservation).deliver_now
    end
    redirect_to reservations_path, notice: '予約をキャンセルしました'
  rescue => e
    logger.debug(e)
    redirect_to reservations_path, alert: '処理中にエラーが発生しました。'
  end
  private

  def set_user
    @user = current_user_corp.present? ? current_user_corp : current_user if logged_in?
  end

  # 選択された施設を@facilityに格納
  def set_selected_facility(condition)
    @facility = Facility.find_by(id: condition[:facility_id].to_i)
  end

  def credit_card_params
    params.require(:credit_card).permit(
      :number, :exp, :holder_name, :cvc
    )
  end
end
