class FacilityDropinSubPlan < ApplicationRecord
  include TimeToday
  acts_as_paranoid

  belongs_to :facility_dropin_plan

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

  def self.recommended_plan(facility, user, checkin, checkout)
    sub_plans = FacilityDropinSubPlan.selectable(facility, user)
  end

  def self.selectable(facility, user)
    fdp_ids = facility.facility_dropin_plans_in_contract(user).pluck(:id)
    fdp_ids.push(nil)
    FacilityDropinSubPlan.where(facility_dropin_plan_id: fdp_ids)
  end

  def self.belongs_to_facility(f_id)
    sub_plans = includes(facility_dropin_plan: :facility).where(facility_dropin_plans: { facilities: { id: f_id }})
    sub_plans.collect { |sp| ["#{sp.facility_dropin_plan.plan_name}-#{sp.name}", sp.id] }
  end
end
