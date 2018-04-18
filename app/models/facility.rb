class Facility < ApplicationRecord
  acts_as_paranoid
  belongs_to :shop
  has_many :facility_plans, dependent: :destroy
  has_many :plans, through: :facility_plans
  has_many :facility_keys, dependent: :destroy
  has_many :facility_temporary_plans, dependent: :destroy

  accepts_nested_attributes_for :facility_plans, reject_if: lambda { |attributes| attributes['plan_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :facility_keys, reject_if: :all_blank

  delegate :name, to: :shop, prefix: true, allow_nil: true

  mount_uploader :image, ImageUploader

  validates :name, presence: true

  scope(:belongs_to_corporation, ->(corporation) { includes(shop: :corporation).where(shops: { corporation_id: corporation.id }) })

  def self.sync_from_api(ks_corporation_id)
    KeystationService.sync_rooms(ks_corporation_id)
  end

  def selectable_plans
    plans.where(default_flag: true)
  end

  def target_plans
    plans + Plan.temporary_plans_belongs_to_facility(self.id)
  end

  def selectable_plans(options = {})
    facility_temporary_plan_ids = facility_temporary_plans.map(&:plan_id)
    not_be_selected = shop.corporation.plans - plans - Plan.where(id: facility_temporary_plan_ids)
    not_be_selected << options[:ftp_id] if options[:ftp_id].present?
    Plan.where(id: not_be_selected)
  end
end
