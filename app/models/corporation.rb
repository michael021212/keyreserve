class Corporation < ApplicationRecord
  acts_as_paranoid

  has_many :corporation_users, dependent: :destroy
  has_many :users, through: :corporation_users
  has_many :plans, dependent: :destroy
  has_many :shops, dependent: :destroy
  has_many :user_contracts, dependent: :destroy
  accepts_nested_attributes_for :users

  validates :name, :kana, presence: true, length: { maximum: 255 }
  validates :tel, presence: true, length: { maximum: 255 }
  validates :postal_code, length: { maximum: 255 }
  validates :address, :note, length: { maximum: 255, allow_blank: true }

  def self.sync_from_api
    KeystationService.sync_corporations
  end

  def selectable_facility_temporary_plans
    selected_facility_temporary_plan_ids = FacilityTemporaryPlan.includes(plan: :corporation).where(plans: { corporation_id: id }).map(&:plan_id)
    selected_facility_plan_ids = FacilityPlan.includes(plan: :corporation).where(plans: {corporation_id: id }).map(&:plan_id)
    plans.where.not(id: selected_facility_temporary_plan_ids.concat(selected_facility_plan_ids))
  end
end
