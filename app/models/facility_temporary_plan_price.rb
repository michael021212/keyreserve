class FacilityTemporaryPlanPrice < ApplicationRecord
  include TimeToday
  acts_as_paranoid
  belongs_to :facility_temporary_plan

  validates :starting_time, :ending_time, :price,  presence: true
  validate :within_business_hours

  delegate :id, to: :facility_temporary_plan, prefix: true, allow_nil: true

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
end
