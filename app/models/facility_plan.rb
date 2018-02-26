class FacilityPlan < ApplicationRecord
  acts_as_paranoid
  belongs_to :facility
  belongs_to :plan
end
