class Reservation < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  include KsCheckinApi
  include KeystationApi

  after_create :create_xymax_special_block_rsv, if: Proc.new{ facility.shop.id == Shop::WBG_SHOP_ID && !block_flag }

  acts_as_paranoid
  belongs_to :facility, optional: true
  belongs_to :user, optional: true
  belongs_to :payment, optional: true
  belongs_to :billing, optional: true

  before_destroy :cancel_payment, if: Proc.new { |reservation| reservation.payment.present? }
  enum state: { unconfirmed: 0, confirmed: 1, canceled: 9 }

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :credit_card, to: :user, prefix: true, allow_nil: true
  delegate :credit_card_id, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :email, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :facility, prefix: true, allow_nil: true
  delegate :shop_corporation_name, to: :facility, prefix: true, allow_nil: true
  delegate :shop_name, to: :facility, prefix: true, allow_nil: true
  delegate :token, to: :payment, prefix: true, allow_nil: true
  delegate :shop_corporation_id, to: :facility, prefix: true, allow_nil: true

  # 請求時に施設が削除されている場合を考慮し、新規作成時のみfacility_idを必須に
  validates :facility_id, presence: true, if: Proc.new{ |r| r.new_record? }
  validates :checkin, :checkout, :usage_period, presence: true
  validate :reservation_already_exists_in_range?

  with_options on: :need_for_payment do
    validates :user_id, :price, presence: true
    validate :need_credit_card
    validate :limit_has_not_exceeded
  end

  scope :with_corporation, ->(corporation) { includes(facility: :shop).where(shops: { corporation_id: corporation.id }) }

  # 指定した時間内の予約一覧
  scope :in_range, ->(range) do
    where(arel_table[:checkout].gt(range.first)).where(arel_table[:checkin].lt(range.last))
  end

  scope(:confirmed_to_i, -> { Reservation.states[:confirmed] })

  scope :ready_to_send, -> do
    target = Time.zone.now + 30.minutes
    where(mail_send_flag: false).where(arel_table[:checkin].lteq(target))
  end

  def create_xymax_special_block_rsv
    return if facility.shop.id != Shop::WBG_SHOP_ID
    start_at = checkin - 1.hour
    finish_at = checkin
    Reservation.create_block_reservatin(start_at, finish_at, facility)
    start_at = checkout
    finish_at = start_at + 1.hour
    Reservation.create_block_reservatin(start_at, finish_at, facility)
  end

  # 請求時に削除済の施設も参照できる必要があったので上書き
  def facility_with_deleted
    Facility.unscope(where: :deleted_at).find_by(id: facility_id)
  end

  def paid_by_credit_card?
    payment.present? && payment.credit_card_id.present?
  end

  def set_payment
    return unless self.user.creditcard?
    return if self.payment.present?
    self.payment = Payment.new(
      user_id: self.user_id,
      corporation_id: self.facility_shop_corporation_id,
      facility_id: self.facility_id,
      credit_card_id: self.user_credit_card_id,
      price: self.price,
    )
  end

  def cancel_payment
    payment.destroy!
  end

  def self.create_block_reservatin(checkin, checkout, facility)
    usage_period = (checkout - checkin) / 60 / 60
    Reservation.create(
      facility_id: facility.id,
      checkin: checkin,
      checkout: checkout,
      usage_period: usage_period,
      state: Reservation.states[:confirmed],
      block_flag: true,
      price: 0
    )
  end

  def self.new_from_spot(spot, user, current_user)
    checkin = Time.zone.parse(spot['checkin'] + " " + spot['checkin_time'])
    facility = Facility.find(spot['facility_id'].to_i)
    price = facility.calc_price(user, checkin, spot['use_hour'].to_f)
    Reservation.new(
      facility_id: spot['facility_id'],
      user_id: user.id,
      reservation_user_id: current_user.id,
      checkin: checkin,
      checkout: checkin + spot['use_hour'].to_f.hours,
      usage_period: spot['use_hour'].to_f,
      state: :confirmed,
      price: price,
      num: spot['use_num'],
      mail_send_flag: false,
      note: spot['note']
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
      payment_method,
      note
    ]
  end

  def self.csv_column_names
    %w[運営会社名 店舗名 施設名 お名前 利用日 利用開始時間 利用終了時間 利用時間 利用人数 状態 利用料金 決済方法 備考]
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
    time = Time.zone.now + 1.days
    canceled? || (time > checkin)
  end

  def cancelable?(user)
    # ザイマックスの場合は無条件に削除ボタン非表示
    return false if user.contract_plan_ids.include?(Plan::XYMAX_PLAN_ID)
    time = Time.zone.now + 1.days
    checkin > time
  end

  def set_check_out
    return if checkin.nil? || usage_period.nil?
    self.checkout = checkin + usage_period.hours
  end

  def set_price
    return if usage_period.nil?
    self.price = facility.calc_price(self.user, self.checkin, self.usage_period) || 0
  end

  def stripe_chargeable?
    user.creditcard? && price != 0
  end

  def save_and_charge!
    ActiveRecord::Base.transaction do
      payment.stripe_charge!
      save!
      send_reserved_mail!
    end
  end

  # 内見予約時にKS、KSCとの連動が正常に出来たかを確認
  def self_viewing_system_link_error?(ks_room_key_info, ksc_reservation_no)
    if facility.rent_with_ksc?
      !(ks_room_key_info.present? && ksc_reservation_no.present?)
    elsif facility.rent_without_ksc?
      !ks_room_key_info.present?
    end
  end

  # 貸し切り施設予約時に紐づく全施設のブロック処理
  def block_for_chartered_place!
    return if !facility.chartered?
    facility.associated_facilities.each do |facility|
      block_reservation = Reservation.new(JSON.parse(self.to_json).merge(
        { id: nil,
          user_id: nil,
          reservation_user_id: nil,
          facility_id: facility.id,
          block_flag: true,
          price: 0,
          num: 0,
          mail_send_flag: true
        }
      ))
      block_reservation.save!
    end
  end

  # 貸し切り施設予約時に紐づく全施設のブロック解除処理
  def unblock_for_chartered_place
    return if !facility.chartered?
    blocked_reservations = Reservation.where(
      block_flag: true,
      checkin: checkin,
      checkout: checkout,
      facility_id: facility.associated_facilities.pluck(:id)
    )
    blocked_reservations.delete_all
  end


  private

  def send_reserved_mail!
    NotificationMailer.reserved(self, self.user_id).deliver_now!
    NotificationMailer.reserved(self, self.user.user_corp.id).deliver_now! if user.user_corp.present?
    NotificationMailer.reserved_to_admin(self).deliver_now!
  end

  def need_credit_card
    return if !(user.present? && user.creditcard?)
    return if user_credit_card.present?
    errors.add(:user_id, :credit_card_is_not_exists)
  end

  def limit_has_not_exceeded
    return if !(user.present? && user.creditcard?)
    return if price.present? && price > 50
    errors.add(:price, :limit_has_not_exceeded)
  end

  def reservation_already_exists_in_range?
    return if checkin.nil? || checkout.nil?
    if facility.reservations.where.not(id: self.id).in_range(checkin..checkout).present?
      errors.add(:checkin, :reservation_already_exists)
    end
  end
end
