module KsCheckinApi
  extend ActiveSupport::Concern

  KS_CHECKIN_API_CLIENT = 'https://identity.key-stations.com'

  def self.set_client(url)
    Faraday.new(url: url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def regist_ksc_reservation!
    ks_checkin_token = facility.shop.corporation.ksc_token
    raise if ks_checkin_token.blank?
    path = 'api/v1/reservations'
    client = KsCheckinApi.set_client(KS_CHECKIN_API_CLIENT)
    res = client.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{ ks_checkin_token }"
      body =  {reservations: [{
                  reservation_no: sprintf("%10d", SecureRandom.random_number(10000000000)),
                  is_japanese: '1',
                  name: user.try(:name),
                  tel: user.try(:tel),
                  email: user.try(:email),
                  checkin: checkin.strftime('%Y-%m-%d %H:%M'),
                  checkout: checkout.strftime('%Y-%m-%d %H:%M')
                 }]
              }
      req.body = body.to_json
    end
      if res.status == 200
        #API連携成功時の処理
      end
  rescue => e
    logger.debug e
  end

end

