class FacilityTemporaryPlan < ApplicationRecord
  acts_as_paranoid
  belongs_to :facility
  belongs_to :plan, optional: true
  has_many :facility_temporary_plan_prices, dependent: :destroy

  accepts_nested_attributes_for :facility_temporary_plan_prices

  delegate :name, to: :plan, prefix: true, allow_nil: true
end
