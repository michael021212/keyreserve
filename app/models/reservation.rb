class Reservation < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  acts_as_paranoid
  belongs_to :facility
  belongs_to :user, optional: true
  belongs_to :payment, optional: true

  before_create :create_payment, if: Proc.new { |reservation| reservation.user_id? }
  enum state: { unconfirmed: 0, confirmed: 1, canceled: 9 }

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gt(range.first)).where(arel_table[:checkin].lt(range.last))
  end
  scope(:confirmed_to_i, -> { Reservation.states[:confirmed] })

  scope :ready_to_send, -> do
    target = Time.zone.now + 30.minutes
    where(mail_send_flag: false).where(arel_table[:checkin].lteq(target))
  end

  def create_payment
    return unless self.user.creditcard?
    return if self.payment.present?
    self.payment = Payment.create!(
      user_id: self.user_id,
      corporation_id: self.facility.shop.corporation_id,
      facility_id: self.facility_id,
      credit_card_id: self.user.credit_card.id,
      price: self.price,
    )
  end

  def self.new_from_spot(spot, user, current_user)
    checkin = Time.zone.parse(spot['checkin'] + " " + spot['checkin_time'])
    facility = Facility.find(spot['facility_id'].to_i)
    price = facility.calc_price(user, checkin, spot['use_hour'].to_i)
    Reservation.new(
      facility_id: spot['facility_id'],
      user_id: user.id,
      reservation_user_id: current_user.id,
      checkin: checkin,
      checkout: checkin + spot['use_hour'].to_i.hours,
      usage_period: spot['use_hour'],
      state: :confirmed,
      price: price,
      num: spot['use_num'],
      mail_send_flag: false
    )
  end

  def self.to_csv(options)
    csv_data = CSV.generate(options) do |csv|
      csv << csv_column_names
      ids = all.sort_by{ |row| row['checkin']}.pluck(:id).reverse!
      # 予約は1000筆ずつに読み込みします
      ids.each_slice(1000) do |id|
        id.map { |id| csv << find(id).csv_column_values }
      end
    end
    bom = "\xFF\xFE".dup.force_encoding('UTF-16LE')
    bom + csv_data.encode('UTF-16LE', undef: :replace, invalid: :replace, replace: '?', cr_newline: true)
  end

  def csv_column_values
    [
      facility.shop.corporation.name,
      facility.shop.name,
      facility.name,
      user.try(:name),
      checkin.strftime('%Y/%m/%d'),
      checkin.strftime('%Y/%m/%d %H:%M'),
      checkout.strftime('%Y/%m/%d %H:%M'),
      usage_period,
      num,
      state_i18n,
      price,
      payment_method
    ]
  end

  def self.csv_column_names
    %w[運営会社名 店舗名 施設名 お名前 利用日 利用開始時間 利用終了時間 利用時間 利用人数 状態 利用料金 決済方法]
  end

  def reservation_user
    User.find_by(id: reservation_user_id)
  end

  def send_cc_mail?
    user_id != reservation_user_id
  end

  def payment_method
    return '' if block_flag?
    payment_id.present? ? 'クレジットカード' : '請求書'
  end

  def deletable?
    payment_id.nil? && (checkin > Time.zone.now)
  end
end
