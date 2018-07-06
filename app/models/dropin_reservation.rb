class DropinReservation < ApplicationRecord
  acts_as_paranoid

  belongs_to :facility
  belongs_to :facility_key
  belongs_to :facility_dropin_plan
  belongs_to :facility_dropin_sub_plan
  belongs_to :user, optional: true
  belongs_to :payment, optional: true

  before_save :create_payment, if: Proc.new { |r| r.user_id? }
  enum state: { unconfirmed: 0, confirmed: 1, canceled: 9 }

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gt(range.first)).where(arel_table[:checkin].lt(range.last))
  end

  scope :ready_to_send, -> do
    target = Time.zone.now + 30.minutes
    where(mail_send_flag: false).where(arel_table[:checkin].lteq(target))
  end

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :email, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :facility, prefix: true, allow_nil: true

  def create_payment
    return unless self.user.creditcard?
    self.payment = Payment.create!(
      user_id: self.reservation_user_id,
      corporation_id: self.user_id,
      facility_id: self.facility_id,
      credit_card_id: self.user.credit_card.id,
      price: self.price,
    )
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
end
