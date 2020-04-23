class Shop < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  belongs_to :corporation
  has_many :facilities, dependent: :destroy
  has_many :information
  has_many :user_contracts

  validates :name, :opening_time, :closing_time, presence: true
  validates :tel,
            length: { maximum: 13 },
            numericality: { only_integer: true, allow_blank: true }
  validate :do_not_over_closing_time

  delegate :name, to: :corporation, prefix: true, allow_nil: true
  delegate :id, to: :corporation, prefix: true, allow_nil: true
  enum shop_type: { general: 0,
                    rent: 1,
                    ks_flexible: 2,
                    public_facility: 3 }

  # カテゴリ毎の統合用店舗ID
  RENT_SHOP_ID = 6
  FLEXIBLE_SHOP_ID = 11
  PUBLIC_SHOP_ID = 18

  # 特別対応を行う店舗ID
  WBG_SHOP_ID = 22

  def self.belongs_to_corporation(c_id)
    Corporation.find(c_id).shops
  end

  # RemoteLockを使用する店舗のID一覧(名前にRemoteLockって含まれる店舗一覧)
  def self.with_remote_lock_shops
    Shop.where('name LIKE ?', '%RemoteLock%')
  end

  def do_not_over_closing_time
    return if opening_time.nil? || closing_time.nil?
    return if opening_time < closing_time
    errors.add(:opening_time, :do_not_over_closing_time)
  end

  def assign_date_for_opening(y, m, d)
    opening_time.change(year: y, month: m, day: d)
  end

  def assign_date_for_closing(y, m, d)
    closing_time.change(year: y, month: m, day: d)
  end

  # 日付範囲が店舗の営業時間内かどうか
  def out_of_business_time?(from, to)
    from < assign_date_for_opening(from.year, from.month, from.day) ||
      to > assign_date_for_closing(to.year, to.month, to.day)
  end

  # 賃貸物件掲載用の店舗かどうか
  def for_rent?
    id == Shop::RENT_SHOP_ID
  end

  # フレキシブル利用用の店舗かどうか
  def for_flexible?
    id == Shop::FLEXIBLE_SHOP_ID
  end

  # 公共施設用の店舗かどうか
  def for_public?
    id == Shop::PUBLIC_SHOP_ID
  end

  def set_geocode
    uri = URI.escape("https://maps.googleapis.com/maps/api/geocode/json?address="+self.address.gsub(" ", "")+"&key=#{Settings.google_key}")
    res = HTTP.get(uri).to_s
    response = JSON.parse(res)
    if response['results'].present?
      self.lat = response["results"][0]["geometry"]["location"]["lat"]
      self.lon = response["results"][0]["geometry"]["location"]["lng"]
    end
  end
end
