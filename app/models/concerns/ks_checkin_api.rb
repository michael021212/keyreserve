module KsCheckinApi
  extend ActiveSupport::Concern

  KS_CHECKIN_API_CLIENT = 'https://identity.key-stations.com'

  def self.set_client(url)
    Faraday.new(url: url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  :patron #何故かfaraday adapterだとうまく動かなかったので
    end
  end

  def regist_ksc_reservation!
    ks_checkin_token = facility.shop.corporation.ksc_token
    raise "ks checkin token is not set" if ks_checkin_token.blank?
    path = '/api/v1/reservations'
    client = KsCheckinApi.set_client(KS_CHECKIN_API_CLIENT)
    res = client.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{ ks_checkin_token }"
      body =  {reservations: [{
                  is_japanese: '1',
                  name: user.try(:name),
                  tel: user.try(:tel),
                  email: user.try(:email),
                  checkin: checkin.strftime('%Y-%m-%d %H:%M'),
                  checkout: checkout.strftime('%Y-%m-%d %H:%M'),
                  is_rent: true
                 }]
              }
      req.body = body.to_json
    end
    raise JSON.parse(res.body)['error_message'] unless res.status == 201
    true
  end

end

