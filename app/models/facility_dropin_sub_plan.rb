class FacilityDropinSubPlan < ApplicationRecord
  include TimeToday
  acts_as_paranoid

  belongs_to :facility_dropin_plan

  validate :within_business_hours

  scope :in_range, ->(range) do
    where(arel_table[:starting_time].lteq(range.first)).where(arel_table[:ending_time].gteq(range.last))
  end

  scope(:belongs_to_facility, ->(f_id) { includes(facility_dropin_plan: :facility).where(facility_dropin_plans: { facilities: { id: f_id }}) })

  validate :within_business_hours

  def within_business_hours
    opening_time = time_today(facility_dropin_plan.facility.shop.opening_time)
    closing_time = time_today(facility_dropin_plan.facility.shop.closing_time)
    errors.add(:starting_time, '開始時間と終了時間が同じです')  if starting_time == ending_time
    errors.add(:starting_time, '開始時間が閉店時間を越しています') if starting_time > ending_time
    if starting_time.present?
      errors.add(:starting_time, '営業時間内の時間を選択してください') if time_today(starting_time) < opening_time
    end
    if ending_time.present?
      errors.add(:ending_time, '営業時間内の時間を選択してください') if time_today(ending_time) > closing_time
    end
  end

  def self.selectable(facility, user)
    fdp_ids = facility.facility_dropin_plans_in_contract(user).pluck(:id)
    fdp_ids.push(nil)
    FacilityDropinSubPlan.where(facility_dropin_plan_id: fdp_ids)
  end

  def self.in_range_return_facilities(checkin, checkout)
    fdps = in_range(checkin..checkout).pluck(:facility_dropin_plan_id)
    f_ids = FacilityDropinPlan.where(id: fdps).pluck(:facility_id)
  end

  def self.selections_with_plan_name(f_id, user)
    facility = Facility.find(f_id)
    facility_dropin_plan_ids = facility.facility_dropin_plans_in_contract(user).pluck(:id)
    sub_plans = belongs_to_facility(f_id).where(facility_dropin_plan_id: facility_dropin_plan_ids)
    sub_plans.collect { |sp| ["#{sp.facility_dropin_plan.plan_name} - #{sp.name}", sp.id] }
  end

  def with_plan_name
    "#{facility_dropin_plan.plan.name}ー#{name}"
  end

  def using_period
    "#{starting_time.strftime('%H:%M')} - #{ending_time.strftime('%H:%M')}"
  end
end
