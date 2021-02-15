module SearchParams

  def valid_search_params?(params)
    return false if empty_params?(params)
    return false if checkout_is_later_than_checkin?(params)
    return false unless set_checkin(params)
    return false unless set_checkout(params, @checkin)
    return false if sudden_reservation?(params, @checkin)
    return false if across_day?(params, @checkin, @checkout)
    return false if outside_business_hours?(params, @checkin, @checkout)
    return false if over_capacity?(params)
    true
  end

  # 検索クエリが空かどうか
  def empty_params?(params)
    if params[:stay].try(:to_bool)
      %i[checkin checkout use_num facility_type].each do |column_name|
        flash.now[:error] = '検索条件を適切に入力してください' and return true if params[column_name].blank? || params[:use_num] == '0'
      end
    else
      %i[checkin checkin_time use_hour use_num facility_type].each do |column_name|
        flash.now[:error] = '検索条件を適切に入力してください' and return true if params[column_name].blank? || params[:use_num] == '0'
      end
    end
    false
  end

  def checkout_is_later_than_checkin?(params)
    return if !params[:stay].try(:to_bool)
    if params[:checkout] <= params[:checkin]
      flash.now[:error] = 'チェックアウト日はチェックイン日より遅い日付を指定してください' and return true
    end
    false
  end

  # 近すぎる予約かどうか
  def sudden_reservation?(params, checkin)
    if params[:stay].try(:to_bool)
      within_time = 6
      sentence = "ご予約はご利用日前日の18時までとなります"
    else
      facility = Facility.find_by('id = ?', params[:facility_id])
      within_time = case facility.try(:shop).try(:id)
                    when Shop::WBG_SHOP_ID
                      24
                    when Shop::REFCOME_SHOP_ID
                      0
                    else
                      0.5
                    end
      sentence = "ご予約はご利用の#{within_time}時間前までとなります"
    end
    if Time.zone.now >= checkin - within_time.hours
      flash.now[:error] = sentence and return true
    end
    false
  end

  # 日をまたぐ予約かどうか
  def across_day?(params, checkin, checkout)
    return false if params[:stay].try(:to_bool)
    if checkin.strftime('%Y/%m/%d') != checkout.strftime('%Y/%m/%d')
      flash.now[:error] = '日をまたいだ予約は出来ません' and return true
    end
    false
  end

  def outside_business_hours?(params, checkin, checkout)
    return if @_params[:action] == 'spot'
    if !params[:stay].try(:to_bool)
      flash[:error] = 'ご予約時間が営業時間外となります' and return true if @facility.shop.out_of_business_time?(checkin, checkout)
    end
    false
  end

  def over_capacity?(params)
    return if @_params[:action] == 'spot'
    flash[:error] = "ご利用人数は#{@facility.max_num}名までです。" and return true if params[:use_num].to_i > @facility.max_num
    false
  end

  # 検索クエリから利用開始日時の設定
  def set_checkin(params)
    if params[:stay].try(:to_bool)
      @checkin = Time.zone.parse(params[:checkin] + " " + "00 : 00")
    else
      @checkin = Time.zone.parse(params[:checkin] + " " + params[:checkin_time])
    end
  rescue => e
    logger.debug(e)
    flash.now[:error] = '不正な検索クエリです' and return false
  end

  # 検索クエリから利用終了日時の設定
  def set_checkout(params, checkin)
    @checkout = checkin + params[:use_hour].to_f.hours
  rescue => e
    legger.debug(e)
    flash.now[:error] = '不正な検索クエリです' and return false
  end
end
