class ReservationsController <  ApplicationController
  before_action :set_user
  before_action :require_login, except: [:spot]
  before_action :require_sms_verification, except: [:spot]
  include ActionView::Helpers::NumberHelper
  include SearchParams

  def index
    @reservations = @user.reservations.order(checkin: :desc)
  end

  def show
    @reservation = @user.reservations.find_by(id: params[:id])
    redirect_to root_path, alert: '指定された予約は存在しません' if @reservation.blank?
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "sample",
               layout: 'pdf.html.erb',
               template: "reservations/receipt_pdf.html.erb",
               page_size: 'A4',
               encoding: 'UTF-8',
               show_as_html: params[:debug].present?
      end
    end
  end

  # 検索ページ
  def spot
    @condition = params[:spot] ||= {}
    @available_shops = Shop.available_shops(@user)
    # @shop_idも検索条件の一つだが、shop_id付きのURLから来る場合には検索処理が走らないよう@conditionには入れない
    @shop_id = params[:shop_id].to_i if params[:shop_id].present?
    @shop_id = params[:spot][:shop_id].to_i if params[:spot][:shop_id].present?
    return render :spot if @condition.blank?
    return render :spot unless valid_search_params?(@condition) #@checkinと@checkoutもset
    if @condition[:stay].try(:to_bool)
      @facilities = Facility.vacancy_facilities(@condition, current_user)
                            .filter_by_shop(@shop_id)
                            .filter_by_users_browsable_range(current_user)
                            .where(published: true)
    else
      @facilities = Facility.reservable_facilities(@checkin, @checkout, @condition, current_user)
                            .filter_by_shop(@shop_id)
                            .filter_by_users_browsable_range(current_user)
                            .where(published: true)
    end
    return render :spot if @facilities.blank?
    @facilities = Facility.order_by_min_price(@facilities, current_user).page(params[:page])
    session[:spot] = @condition
    @facility_types = Facility.facility_types
  end

  # 1.ご利用情報入力
  def new
    if params[:spot].present?
      @condition = params[:spot]
    elsif session[:spot].present?
      @condition = session[:spot].map{|k,v| [k.to_sym,v]}.to_h
    else
      @condition = {}
    end
    session[:reservation_id] = nil
    @facility = @user.login_spots.find_by(id: params[:facility_id])
    set_choosable_pack_plans
    if @facility.blank?
      flash[:error] = '検索条件を入力してください'
      redirect_to spot_reservations_path
    end
  end

  # 利用料金の計算用
  def price
    @condition = params[:spot]
    return render json: { price: '' } if empty_params?(@condition)
    @facility = @user.login_spots.find_by(id: @condition[:facility_id]) if @condition[:facility_id].present?
    return render json: { price: '' } if @facility.blank?
    set_checkin(@condition)
    if @condition[:stay].try(:to_bool)
      price = @facility.calc_price_for_stay(@user, @condition[:checkin], @condition[:checkout])
    else
      price = @condition[:plan_type] == 'temporary' ? @facility.calc_price(@user, @checkin, @condition[:use_hour].to_f) : @facility.calc_price_for_pack(@user, @condition[:pack_plan_id])
    end
    render json: { price: number_with_delimiter(price) }
  end

  # クレカ情報登録処理
  def credit_card
    @condition = session[:spot].map{|k,v| [k.to_sym,v]}.to_h
    set_selected_facility(@condition)
    return redirect_to confirm_reservations_url if current_user.credit_card.present?
    @credit_card = current_user.build_credit_card(credit_card_params)
    return render :credit_card unless @credit_card.valid?
    begin
      @credit_card.prepare_stripe_card
      @credit_card.save!
      current_user.activated!
      redirect_to confirm_reservations_url(credit_card: true)
    rescue => e
      logger.warn("#{e.class.name} #{e.message}")
      flash[:error] = 'クレジットカードの登録に失敗しました。入力情報が正しいか、今一度ご確認ください。'
      render :credit_card
    end
  end

  # 2.カード情報入力
  # 3.確認画面
  def confirm
    if params[:page] == 'shop' || params[:credit_card].present?
      @condition = session[:spot].map{|k,v| [k.to_sym,v]}.to_h
    else
      @condition = params[:spot] ||= {}
    end
    session[:spot] = @condition if @condition.present?
    set_selected_facility(@condition)
    set_choosable_pack_plans
    set_selected_pack_plan_id(@condition)

    # 施設未選択なら検索フォームにリダイレクト
    if @facility.blank?
      flash[:error] = '施設を選択してください'
      redirect_to spot_reservations_path and return
    end

    # 検索クエリが正常かどうかチェック
    return render :new unless valid_search_params?(@condition)

    if !@condition[:stay].try(:to_bool)
      @price = @condition[:plan_type] == 'temporary' ? @facility.calc_price(@user, @checkin, @condition[:use_hour].to_f) : @facility.calc_price_for_pack(@user, @condition[:pack_plan_id])
    else
      @price = @facility.calc_price_for_stay(@user, @condition[:checkin], @condition[:checkout])
    end

    # クレカ払い & クレカの登録がない場合は登録画面に遷移
    if @user.credit_card.blank? && @user.creditcard?
      @credit_card = current_user.build_credit_card
      return render :credit_card
    end
  end

  def create
    ks_room_key_info = false
    ksc_reservation_no = false
    @condition = session[:spot] ||= {}
    if @condition.blank?
      flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、再度お手続きお願いいたします。'
      redirect_to spot_reservations_url and return
    end
    note = Hash['note', params[:spot][:note]]
    @condition.merge!(note)
    @reservation = Reservation.new_from_spot(@condition, @user, current_user)
    @reservation.set_payment
    ActiveRecord::Base.transaction do
      # KS Checkinと連動させる際の値取得処理
      if @reservation.facility.rent_with_ksc?
        ks_room_key_info = @reservation.fetch_ks_room_key
        if @reservation.facility.rent_with_ksc? && ks_room_key_info.present?
          ksc_reservation_no = @reservation.regist_ksc_reservation
        end
        if @reservation.self_viewing_system_link_error?(ks_room_key_info, ksc_reservation_no)
          flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、運営事務局までお尋ねください'
          redirect_to spot_reservations_url and return
        end
      end
      @reservation.save!
      @reservation.block_for_chartered_place!
      session[:spot] = nil
      session[:reservation_id] = @reservation.id
      @reservation.payment.stripe_charge! if @reservation.stripe_chargeable?
      NotificationMailer.reserved(@reservation, @reservation.user_id, ksc_reservation_no, ks_room_key_info).deliver_now if @reservation.send_cc_mail?
      NotificationMailer.reserved(@reservation, @reservation.reservation_user_id, ksc_reservation_no, ks_room_key_info).deliver_now
      NotificationMailer.reserved_to_corporation(@reservation).deliver_now if @reservation.facility.shop.corporation.try(:email).present?
      NotificationMailer.reserved_to_admin(@reservation).deliver_now
    end
    redirect_to thanks_reservations_url
  rescue => e
    logger.debug(e)
    flash[:alert] = '予約時に予期せぬエラーが発生しました。お手数となりますが、運営事務局までお尋ねください'
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
      @reservation.unblock_for_chartered_place
      NotificationMailer.reservation_canceled(@reservation, @reservation.user_id).deliver_now if @reservation.send_cc_mail?
      NotificationMailer.reservation_canceled(@reservation, @reservation.reservation_user_id).deliver_now
      NotificationMailer.reservation_canceled_to_corporation(@reservation).deliver_now if @reservation.facility.shop.corporation.try(:email).present?
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

  def set_choosable_pack_plans
    @choosable_pack_plans = @facility.choosable_pack_plans(@user).flatten.to_activerecord_relation.order(:unit_time)
  end

  def set_selected_pack_plan_id(condition)
    @selected_pack_plan_id = @choosable_pack_plans.find_by(id: condition[:pack_plan_id]).id if condition[:pack_plan_id].present?
  end

  def credit_card_params
    params.require(:credit_card).permit(
      :number, :exp, :holder_name, :cvc
    )
  end
end
