class FacilityPackPlan < ApplicationRecord
  acts_as_paranoid
  mount_uploader :guide_file, FileUploader

  belongs_to :facility
  belongs_to :plan, optional: true

  validates :ks_room_key_id, :unit_time, :unit_price, presence: true

  delegate :name, to: :plan, prefix: true, allow_nil: true

  scope :plan_id_nil, -> { where(plan_id: nil) }
  scope :target_plan_ids, ->(plan_ids) { where(plan_id: plan_ids) }
  scope :linked_with_user, ->(user) do
    plans = user&.contract_plan_ids.presence || []
    target_plan_ids(plans)
  end

  scope :not_zero_yen, -> { where.not(unit_price: 0) }
  scope :for_not_member, -> { plan_id_nil }
  scope :select_pack_plans_for_user_condition, ->(user = nil) { linked_with_user(user).presence || for_not_member }
end
