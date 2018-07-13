class FacilityDropinPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :facility
  belongs_to :plan, optional: true
  has_many :facility_dropin_sub_plans, index_errors: true, dependent: :destroy

  accepts_nested_attributes_for :facility_dropin_sub_plans, reject_if: lambda { |attributes| attributes['price'].blank? || attributes['name'].blank? }, allow_destroy: true
end
