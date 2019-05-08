module KeystationApi
  extend ActiveSupport::Concern

  KS_API_CLIENT = 'https://key-stations.com'

  def self.set_client(url)
    Faraday.new(url: url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  :patron
    end
  end

  # 鍵のIDからパスを取得 #reservationのインスタンスメソッド
  def fetch_ks_room_key!
    key = facility.facility_keys.first
    conn = KeystationApi::set_client(KS_API_CLIENT)
    res = conn.get do |req|
      req.url "/api/v1/room_keys/#{ key.ks_room_key_id }"
      # TODO: 本当は企業毎に変える必要ありそう
      req.headers['Authorization'] = "Bearer #{ ENV['KS_PARTNER_TOKEN'] }"
    end
    res = JSON.parse(res.body)
    raise res.find{ |k,v| k == 'error' }.second if res.find{ |k,v| k == 'error' }.present?
    res
  rescue => e
    logger.debug e
    raise e.message
  end

end
