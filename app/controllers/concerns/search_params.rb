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
    if params[:checkin].blank? || params[:checkin_time].blank? || params[:use_hour].blank? || params[:use_num].blank?
      flash[:error] = '検索条件を適切に入力してください' and return true
    end
    false
  end

  # 近すぎる予約かどうか
  def sudden_reservation?(params, checkin)
    if Time.zone.now >= checkin - 30.minutes
      flash[:error] = 'ご予約はご利用の30分前までとなります' and return true
    end
    false
  end

  # 日をまたぐ予約かどうか
  def across_day?(params, checkin, checkout)
    if checkin.strftime('%Y/%m/%d') != checkout.strftime('%Y/%m/%d')
      flash[:error] = '日をまたいだ予約は出来ません' and return true
    end
    false
  end

  # 検索クエリから利用開始日時の設定
  def set_checkin(params)
    @checkin = Time.zone.parse(params[:checkin] + " " + params[:checkin_time])
  rescue => e
    legger.debug(e)
    flash[:error] = '不正な検索クエリです' and return false
  end

  # 検索クエリから利用終了日時の設定
  def set_checkout(params, checkin)
    @checkout = checkin + params[:use_hour].to_i.hours
  rescue => e
    legger.debug(e)
    flash[:error] = '不正な検索クエリです' and return false
  end

end
