class DropinReservation < ApplicationRecord
  acts_as_paranoid

  belongs_to :facility
  belongs_to :facility_dropin_plan
  belongs_to :facility_dropin_sub_plan
  belongs_to :user, optional: true
  belongs_to :payment, optional: true

  before_save :create_payment, if: Proc.new { |r| r.user_id? }
  enum state: { unconfirmed: 0, confirmed: 1, canceled: 9 }

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gt(range.first)).where(arel_table[:checkin].lt(range.last))
  end

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
    DropinReservation.new(
      facility_id: sub_plan.facility_dropin_plan.facility.id,
      facility_dropin_plan_id: sub_plan.facility_dropin_plan.id,
      facility_dropin_sub_plan_id: sub_plan.id,
      user_id: user.id,
      reservation_user_id: current_user.id,
      checkin: sub_plan.starting_time.change(year: y, month: m, day: d),
      checkout: sub_plan.ending_time.change(year: y, month: m, day: d),
      state: :confirmed,
      price: sub_plan.price,
      block_flag: false,
      mail_send_flag: true # TODO 暫定
    )
  end
end
