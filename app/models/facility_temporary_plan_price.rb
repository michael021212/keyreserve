class FacilityTemporaryPlanPrice < ApplicationRecord
  acts_as_paranoid
  belongs_to :facility_temporary_plan

  validates :starting_time,  :ending_time, :price,  presence: true

end
