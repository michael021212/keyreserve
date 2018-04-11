class FacilityTemporaryPlan < ApplicationRecord

  acts_as_paranoid
  belongs_to :facility
  belongs_to :plan, optional: true
  has_many :facility_temporary_plan_prices, index_errors: true, dependent: :destroy

  validates :standard_price_per_hour, :standard_price_per_day,  presence: true
  validate :overlap_facility_temporary_plan_prices

  accepts_nested_attributes_for :facility_temporary_plan_prices, reject_if: lambda { |attributes| attributes['price'].blank? }, allow_destroy: true

  delegate :name, to: :plan, prefix: true, allow_nil: true

  scope(:belongs_to_corporation, ->(corporation) { includes(facility: { shop: :corporation }).where(facilities: { shops: { corporation_id: corporation.id }}) })

  def overlap_facility_temporary_plan_prices
    arr = []
    facility_temporary_plan_prices.each do |pp|
      range = "#{pp.starting_time.strftime('%H')}-#{pp.ending_time.strftime('%H')}"
      arr << range
    end
    arr_sort = arr.sort
    arr_sort.each_with_index { |item, idx|
      next if arr_sort[idx+1].blank?
      first_end = item.split('-')[1].to_i
      sec_start = arr_sort[idx+1].split('-')[0].to_i
      if first_end > sec_start
        errors.add(:base, '')
        facility_temporary_plan_prices[arr.index(item)+1].errors.add(:starting_time, '選択した時間帯が重複されました')
        facility_temporary_plan_prices[arr.index(item)].errors.add(:ending_time, '選択した時間帯が重複されました')
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
    arr.each_slice(2).to_a
  end
end
