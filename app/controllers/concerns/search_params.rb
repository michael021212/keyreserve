module SearchParams

  def valid_search_params?(params)
    return false if empty_params?(params)
    return false unless set_checkin(params)
    return false unless set_checkout(params, @checkin)
    return false if sudden_reservation?(params, @checkin)
    return false if across_day?(params, @checkin, @checkout)
    true
  end

  # 検索クエリが空かどうか
  def empty_params?(params)
    if params[:checkin].blank? || params[:checkin_time].blank? || params[:use_hour].blank? || params[:use_num].blank? || params[:facility_type].blank?
      flash.now[:error] = '検索条件を適切に入力してください' and return true
    end
    false
  end

  # 近すぎる予約かどうか
  def sudden_reservation?(params, checkin)
    facility = Facility.find_by('id = ?', params[:facility_id])
    within_time = case facility.try(:shop).try(:id)
                  when Shop::WBG_SHOP_ID
                    24
                  when Shop::REFCOME_SHOP_ID
                    0
                  else
                    0.5
                  end
    if Time.zone.now >= checkin - within_time.hours
      flash.now[:error] = "ご予約はご利用の#{within_time}時間前までとなります" and return true
    end
    false
  end

  # 日をまたぐ予約かどうか
  def across_day?(params, checkin, checkout)
    if checkin.strftime('%Y/%m/%d') != checkout.strftime('%Y/%m/%d')
      flash.now[:error] = '日をまたいだ予約は出来ません' and return true
    end
    false
  end

  # 検索クエリから利用開始日時の設定
  def set_checkin(params)
    @checkin = Time.zone.parse(params[:checkin] + " " + params[:checkin_time])
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
