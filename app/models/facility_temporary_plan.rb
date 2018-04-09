class FacilityTemporaryPlan < ApplicationRecord

  acts_as_paranoid
  belongs_to :facility
  belongs_to :plan, optional: true
  has_many :facility_temporary_plan_prices, dependent: :destroy

  validates :standard_price_per_hour, :standard_price_per_day,  presence: true

  accepts_nested_attributes_for :facility_temporary_plan_prices, reject_if: lambda { |attributes| attributes['price'].blank? }, allow_destroy: true

  delegate :name, to: :plan, prefix: true, allow_nil: true

  def standard_price_per_hour_area
    arr = []
    opening_time = facility.shop.opening_time
    closing_time = facility.shop.closing_time
    facility_temporary_plan_prices.order(:starting_time).each_with_index do |pp, i|
      next_price_block = facility_temporary_plan_prices.where('starting_time >?', pp.ending_time).order(:starting_time).first
      if i == 0 && pp.starting_time != opening_time
        arr << opening_time
        arr << pp.starting_time
      end
      if next_price_block.present?
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
