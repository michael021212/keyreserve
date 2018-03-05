class KeystationService
  def self.initialize
    # TODO Change url and partner token
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.headers['Authorization'] = "Bearer #{Settings.keyreserve_partner_token}"
    conn
  end

  # KeyStationの法人一覧を取得する
  def self.sync_corporations
    initialize
    response = initialize.get '/api/v1/corporations.json'
    if success?(response)
      api_corporations = JSON.parse(response.body)
      @ks_corporations = []
      api_corporations['corporations'].each do |c|
        c_id = c['corporation']['id']
        c_name = c['corporation']['name']
        c = [c_name, c_id]
        @ks_corporations << c
      end
    end
    return @ks_corporations
  end

  # 法人IDでKeyStationの部屋一覧を取得し、部屋と紐つく鍵を選択項目として返す
  def self.sync_rooms(c_id)
    initialize
    response = initialize.get "/api/v1/rooms.json", params={ 'corporation_id': c_id }
    if success?(response)
      api_rooms = JSON.parse(response.body)
      keys_array = api_rooms['rooms'].map { |rooms| rooms['room']['room_keys'] }
      key_ids_array = keys_array.flatten.map { |k| k['room_key']['id'] }
      key_opts = []
      key_ids_array.each do |key_id|
        name = KeystationService.sync_room_key_name(key_id)
        key_opts << [name, key_id]
      end
    end
    return key_opts
  end

  private

  # 部屋鍵の名前を取得する
  def self.sync_room_key_name(rk_id)
    initialize
    response = initialize.get "/api/v1/room_keys/#{rk_id}.json"
    if success?(response)
      api_room_key_detail = JSON.parse(response.body)
      name = api_room_key_detail['room_key']['name']
    end
    return name
  end

  # 部屋鍵のパスワードを取得する
  def self.sync_room_key_password(rk_id)
    initialize
    response = initialize.get "/api/v1/room_keys/#{rk_id}.json"
    if success?(response)
      api_room_key_detail = JSON.parse(response.body)
      password = api_room_key_detail['room_key']['password']
    end
    return password
  end

  def self.success?(response)
    response.body && response.status == 200
  end
end
