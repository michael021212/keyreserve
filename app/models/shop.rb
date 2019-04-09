class Shop < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  belongs_to :corporation
  has_many :facilities, dependent: :destroy
  has_many :information
  has_many :user_contracts

  before_validation :geocode
  validates :name, :opening_time, :closing_time, presence: true
  validates :tel,
            length: { maximum: 13 },
            numericality: { only_integer: true, allow_blank: true }
  validate :business_time

  def self.belongs_to_corporation(c_id)
    Corporation.find(c_id).shops
  end

  def business_time
    errors.add(:opening_time, '開店時間は閉店時間より早めにしてください') if opening_time > closing_time
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

  private
  def geocode
    uri = URI.escape("https://maps.googleapis.com/maps/api/geocode/json?address="+self.address.gsub(" ", "")+"&key=#{Settings.google_key}")
    res = HTTP.get(uri).to_s
    response = JSON.parse(res)
    self.lat = response["results"][0]["geometry"]["location"]["lat"]
    self.lon = response["results"][0]["geometry"]["location"]["lng"]
  end
end
