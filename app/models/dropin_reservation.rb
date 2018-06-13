class DropinReservation < ApplicationRecord
  acts_as_paranoid

  belongs_to :facility
  belongs_to :facility_dropin_plan
  belongs_to :facility_dropin_sub_plan
  belongs_to :user, optional: true
  belongs_to :payment, optional: true

  enum state: { unconfirmed: 0, confirmed: 1, canceled: 9 }

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gt(range.first)).where(arel_table[:checkin].lt(range.last))
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

  def self.unavailable_dropin_facilities_arr(checkin, checkout)
    exclude_facility_ids = []
    f_ids = in_range(checkin .. checkout).pluck(:facility_id).uniq
    Facility.where(id: f_ids).each do |f|
      dropin_reservation_num = f.dropin_reservations.in_range(checkin..checkout).count
      key_num = f.facility_keys.count
      exclude_facility_ids << f.id if dropin_reservation_num >= key_num
    end
    exclude_facility_ids
  end
end
