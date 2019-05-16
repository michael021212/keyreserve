class FacilityTemporaryPlanPrice < ApplicationRecord
  include TimeToday
  acts_as_paranoid
  belongs_to :facility_temporary_plan

  scope :not_zero_yen, -> { where.not(price: 0) }
  scope :target_plans, ->(plans) { where(facility_temporary_plan: plans) }
  scope :in_time, ->(target_time) do
    al = FacilityTemporaryPlanPrice.arel_table
    where(al[:starting_time].lteq(target_time.to_s(:time))).where(al[:ending_time].gt(target_time.to_s(:time)))
  end

  validates :starting_time, :ending_time, :price,  presence: true
  validate :within_business_hours

  def within_business_hours
    opening_time = time_today(facility_temporary_plan.facility.shop.opening_time)
    closing_time = time_today(facility_temporary_plan.facility.shop.closing_time)
    errors.add(:starting_time, '開始時間と終了時間が同じです')  if starting_time == ending_time
    errors.add(:starting_time, '開始時間が閉店時間を越しています') if starting_time > ending_time
    if starting_time.present?
      errors.add(:starting_time, '営業時間内の時間を選択してください') if time_today(starting_time) < opening_time
    end
    if ending_time.present?
      errors.add(:ending_time, '営業時間内の時間を選択してください') if time_today(ending_time) > closing_time
    end
  end
  
  def self.squeeze_from_plans_and_time(plans, target_time)
    facility_temporary_plan_prices = not_zero_yen.target_plans(plans)
    facility_temporary_plan_prices.in_time(target_time) if target_time.present?
  end
end
