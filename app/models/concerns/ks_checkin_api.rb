module KsCheckinApi
  extend ActiveSupport::Concern

  API_CLIENT = Settings[:ks_checkin_endpoint]

  def self.set_client(url)
    Faraday.new(url: url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  :patron #何故かfaraday adapterだとうまく動かなかったので
    end
  end

  # -- reservation のインスタンスメソッド --

  def update_ksc_reservation
    return false if ksc_reservation_no.blank?
    ks_checkin_token = facility.shop.corporation.ksc_token
    raise "ks checkin token is not set" if ks_checkin_token.blank?
    path = "/api/v1/reservations/#{ksc_reservation_no}"
    client = KsCheckinApi.set_client(API_CLIENT)
    key = facility.facility_keys.first
    res = client.patch do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{ ks_checkin_token }"
      body =  { ks_room_key_id: key.try(:ks_room_key_id) }
      req.body = body.to_json
    end
    unless res.status == 200
      logger.debug JSON.parse(res.body)['error_message']
      return false
    end
  rescue => e
    logger.debug e.message
    false
  end

  def regist_ksc_reservation
    ks_checkin_token = facility.shop.corporation.ksc_token
    raise "ks checkin token is not set" if ks_checkin_token.blank?
    path = '/api/v1/reservations'
    client = KsCheckinApi.set_client(API_CLIENT)
    key = facility.facility_keys.first
    reservation_no = SecureRandom.random_number(10000000000)
    reservation_type = set_reservation_type
    res = client.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{ ks_checkin_token }"
      body =  {reservations: [{
                  is_japanese: '1',
                  reservation_no: reservation_no,
                  name: user.try(:name),
                  tel: user.try(:tel),
                  email: user.try(:email),
                  checkin: checkin.strftime('%Y-%m-%d %H:%M'),
                  checkout: checkout.strftime('%Y-%m-%d %H:%M'),
                  remarks: facility.address,
                  ks_room_key_id: key.try(:ks_room_key_id),
                  reservation_type: reservation_type
                 }]
              }
      req.body = body.to_json
    end
    unless res.status == 201
      logger.debug JSON.parse(res.body)['error_message']
      return false
    end
    reservation_no
  rescue => e
    logger.debug e.message
    false
  end

  private
  def set_reservation_type
    ksc_reservation_type = {general: 0, rent: 1, car_share: 2, flexible: 4}
    return ksc_reservation_type[:rent] if facility.rent?
    return ksc_reservation_type[:car_share] if facility.car?
    return ksc_reservation_type[:flexible] if facility.ks_flexible?
    return ksc_reservation_type[:general]
  end

end

