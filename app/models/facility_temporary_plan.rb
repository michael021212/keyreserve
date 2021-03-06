class FacilityTemporaryPlan < ApplicationRecord
  acts_as_paranoid
  mount_uploader :guide_file, FileUploader

  belongs_to :facility
  belongs_to :plan, optional: true
  has_many :facility_temporary_plan_prices, index_errors: true, dependent: :destroy

  validates :ks_room_key_id, :standard_price_per_hour, :standard_price_per_day,  presence: true
  validate :overlap_facility_temporary_plan_prices

  accepts_nested_attributes_for :facility_temporary_plan_prices, reject_if: lambda { |attributes| attributes['price'].blank? }, allow_destroy: true

  delegate :name, to: :plan, prefix: true, allow_nil: true

  scope(:belongs_to_corporation, ->(corporation) { includes(facility: { shop: :corporation }).where(facilities: { shops: { corporation_id: corporation.id }}) })
  scope(:exclude_ks_room_key_ids, ->(facility_id) { includes(:facility).where(facilities: { id: facility_id }).pluck(:ks_room_key_id) })
  scope :not_zero_yen, -> { where.not(standard_price_per_hour: 0) }
  scope :not_zero_yen_for_stay, -> { where.not(standard_price_per_day: 0) }
  scope :plan_id_nil, -> { where(plan_id: nil) }
  scope :target_plan_ids, ->(plan_ids) { where(plan_id: plan_ids) }
  scope :linked_with_user, ->(user) do
    plans = user&.contract_plan_ids.presence || []
    target_plan_ids(plans)
  end
  scope :for_not_member, -> { plan_id_nil }
  scope :for_not_member_for_stay, -> { not_zero_yen_for_stay.plan_id_nil }
  scope :select_plans_for_user_condition, ->(user=nil) { linked_with_user(user).presence || for_not_member }
  scope :select_plans_for_user_condition_for_stay, ->(user=nil) { linked_with_user(user).presence || for_not_member_for_stay }

  def overlap_facility_temporary_plan_prices
    time_period_with_indices = []
    facility_temporary_plan_prices.each_with_index do |pp, idx|
      time_period_with_index = "#{pp.starting_time.strftime('%H')}-#{pp.ending_time.strftime('%H')}-#{idx}"
      time_period_with_indices << time_period_with_index
    end
    time_period_with_indices_sort = time_period_with_indices.sort
    time_period_with_indices_sort.each_with_index { |time_period_with_index, idx|
      next if time_period_with_indices[idx+1].blank?
      first_end = time_period_with_index.split('-')[1].to_i
      sec_start = time_period_with_indices_sort[idx+1].split('-')[0].to_i
      first_idx =  time_period_with_indices_sort[idx].split('-')[2].to_i
      sec_idx =  time_period_with_indices_sort[idx+1].split('-')[2].to_i
      if first_end > sec_start
        errors.add(:base, '')
        facility_temporary_plan_prices[first_idx].errors.add(:ending_time, '?????????????????????????????????')
        facility_temporary_plan_prices[sec_idx].errors.add(:starting_time, '?????????????????????????????????')
      end
    }
  end

  def standard_price_per_hour_area
    arr = []
    opening_time = facility.shop.opening_time
    closing_time = facility.shop.closing_time
    facility_temporary_plan_prices.order(:starting_time).each_with_index do |pp, i|
      next_price_block = facility_temporary_plan_prices.where('starting_time >=?', pp.ending_time).order(:starting_time).first
      if i == 0 && pp.starting_time != opening_time
        arr << opening_time
        arr << pp.starting_time
      end
      if next_price_block.present?
        next if pp.ending_time == next_price_block.starting_time
        arr << pp.ending_time
        arr << next_price_block.starting_time
      else
        next if pp.ending_time == closing_time
        arr << pp.ending_time
        arr << closing_time
      end
    end
    arr << opening_time << closing_time if facility_temporary_plan_prices.blank?
    arr.each_slice(2).to_a
  end
end
