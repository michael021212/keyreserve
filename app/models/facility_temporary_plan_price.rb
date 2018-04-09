class FacilityTemporaryPlanPrice < ApplicationRecord
  acts_as_paranoid
  belongs_to :facility_temporary_plan

  validates :starting_time, :ending_time, :price,  presence: true
  validate :within_business_hours

  def within_business_hours
    opening_time = Shop.time_today(facility_temporary_plan.facility.shop.opening_time)
    closing_time = Shop.time_today(facility_temporary_plan.facility.shop.closing_time)
    if starting_time == ending_time
      errors.add(:starting_time, '開始時間と終了時間が同じです')
    elsif starting_time < opening_time
      errors.add(:starting_time, '営業時間内の時間を選択してください')
    elsif starting_time > ending_time
      errors.add(:starting_time, '開始時間が閉店時間を越しています')
    end
    errors.add(:ending_time, '営業時間内の時間を選択してください') if ending_time > closing_time
  end
end
