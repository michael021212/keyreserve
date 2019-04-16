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

  def regist_reservation
    path = 'api/v1/reservations'
    ks_checkin_token = facility.shop.corporation.ksc_token
    client = KsCheckinApi.set_client(KS_CHECKIN_API_CLIENT)
    res = client.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{ ks_checkin_token }"
      body =  {'reservations': [{
                 'reservation_no': '12345678',
                 'is_japanese': '1',
                 'name': user.try(:name),
                 'tel': user.try(:tel),
                 'email': user.try(:email),
                 'checkin': checkin.strftime('%Y-%m-%d %H:%M'),
                 'checkout': checkout.strftime('%Y-%m-%d %H:%M'),
                 }]
              }
      req.body = body.to_json
    end
  end

end

