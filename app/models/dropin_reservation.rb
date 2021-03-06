class DropinReservation < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  acts_as_paranoid

  belongs_to :facility, optional: true
  belongs_to :facility_key
  belongs_to :facility_dropin_plan
  belongs_to :facility_dropin_sub_plan
  belongs_to :user, optional: true
  belongs_to :payment, optional: true
  belongs_to :billing, optional: true

  before_destroy :cancel_payment, if: Proc.new { |r| r.payment.present? }
  enum state: { unconfirmed: 0, confirmed: 1, canceled: 9 }

  # 請求時に施設が削除されている場合を考慮し、新規作成時のみfacility_idを必須に
  validates :facility_id, presence: true, if: Proc.new{ |r| r.new_record? }

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gt(range.first)).where(arel_table[:checkin].lt(range.last))
  end
  scope(:confirmed_to_i, -> { states[:confirmed] })

  scope :ready_to_send, -> do
    target = Time.zone.now + 30.minutes
    where(mail_send_flag: false).where(arel_table[:checkin].lteq(target))
  end
  
  scope :with_corporation, ->(target_corporation) { includes(facility: :shop).where(shops: { corporation_id: target_corporation.id }) }

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :email, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :facility, prefix: true, allow_nil: true
  delegate :shop_corporation_name, to: :facility, prefix: true, allow_nil: true
  delegate :shop_name, to: :facility, prefix: true, allow_nil: true
  delegate :using_hours, to: :facility_dropin_sub_plan, prefix: true, allow_nil: true
  delegate :with_plan_name, to: :facility_dropin_sub_plan, prefix: true, allow_nil: true
  delegate :token, to: :payment, prefix: true, allow_nil: true

  # 請求時に削除済の施設も参照できる必要があったので上書き
  def facility_with_deleted
    Facility.unscope(where: :deleted_at).find_by(id: facility_id)
  end

  def paid_by_credit_card?
    payment.present? && payment.credit_card_id.present?
  end

  def set_payment
    return unless self.user.creditcard?
    self.payment = Payment.new(
      user_id: self.reservation_user_id,
      corporation_id: self.user_id,
      facility_id: self.facility_id,
      credit_card_id: self.user.credit_card.id,
      price: self.price,
    )
  end

  def cancel_payment
    payment.destroy!
  end

  def self.new_from_dropin_spot(dropin_spot, user, current_user)
    sub_plan = FacilityDropinSubPlan.find(dropin_spot['sub_plan'])
    y, m, d = dropin_spot['checkin'].split('/')
    checkin = sub_plan.starting_time.change(year: y, month: m, day: d)
    checkout = sub_plan.ending_time.change(year: y, month: m, day: d)
    DropinReservation.new(
      facility_id: sub_plan.facility_dropin_plan.facility.id,
      facility_dropin_plan_id: sub_plan.facility_dropin_plan.id,
      facility_dropin_sub_plan_id: sub_plan.id,
      facility_key_id: sub_plan.assign_facility_key(checkin, checkout),
      user_id: user.id,
      reservation_user_id: current_user.id,
      checkin: checkin,
      checkout: checkout,
      state: :confirmed,
      price: sub_plan.price,
      mail_send_flag: false
    )
  end

  def reservation_user
    return if reservation_user_id.nil?
    User.find(reservation_user_id)
  end

  def send_dropin_reserved_mails
    NotificationMailer.dropin_reserved(self, user_id).deliver_now
    NotificationMailer.dropin_reserved(self, reservation_user_id).deliver_now if reservation_user_id != user_id
    NotificationMailer.dropin_reserved_to_admin(self).deliver_now
  end

  def send_cc_mail?
    user_id != reservation_user_id
  end

  def stripe_chargeable?
    user.creditcard? && price != 0
  end

  def self.to_csv(options)
    csv_data = CSV.generate(options) do |csv|
      csv << csv_column_names
      ids = all.sort_by{ |row| row['checkin'] }.pluck(:id).reverse!
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
      facility_dropin_sub_plan.with_plan_name,
      checkin.strftime('%Y/%m/%d'),
      checkin.strftime('%Y/%m/%d %H:%M'),
      checkout.strftime('%Y/%m/%d %H:%M'),
      facility_dropin_sub_plan.using_hours,
      state_i18n,
      price
    ]
  end

  def self.csv_column_names
    %w[運営会社名 店舗名 施設名 お名前 ご利用プラン 利用日 利用開始時間 利用終了時間 利用時間 状態 利用料金]
  end

  def deletable?
    time = Time.zone.now + 1.days
    canceled? || (time > checkin)
  end

  def cancelable?
    time = Time.zone.now + 1.days
    checkin > time
  end
end
