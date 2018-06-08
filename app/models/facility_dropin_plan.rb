class FacilityDropinPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :facility
  belongs_to :plan, optional: true
  has_many :facility_dropin_sub_plans, index_errors: true, dependent: :destroy
  has_many :dropin_keys, index_errors: true, dependent: :destroy

  accepts_nested_attributes_for :facility_dropin_sub_plans, reject_if: lambda { |attributes| attributes['price'].blank? || attributes['name'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :dropin_keys, reject_if: lambda { |attributes| attributes['ks_room_key_id'].blank? }, allow_destroy: true

  validates :usage_fee_per_hour, presence: true
end
