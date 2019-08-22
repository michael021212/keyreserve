class FacilityDropinPlan < ApplicationRecord
  acts_as_paranoid
  mount_uploader :guide_file, PdfUploader

  belongs_to :facility
  belongs_to :plan, optional: true
  has_many :facility_dropin_sub_plans, index_errors: true, dependent: :destroy

  accepts_nested_attributes_for :facility_dropin_sub_plans, reject_if: lambda { |attributes| attributes['price'].blank? || attributes['name'].blank? }, allow_destroy: true

  def plan_name
    plan.try(:name).present? ? plan.name : '非会員'
  end
end
