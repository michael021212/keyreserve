class FacilityDropinSubPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :facility_dropin_plan
end
