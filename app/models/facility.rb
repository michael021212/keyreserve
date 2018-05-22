class Facility < ApplicationRecord

  acts_as_paranoid
  belongs_to :shop
  has_many :facility_plans, dependent: :destroy
  has_many :plans, through: :facility_plans
  has_many :facility_keys, dependent: :destroy
  has_many :facility_temporary_plans, dependent: :destroy
  has_many :reservations, dependent: :destroy

  enum facility_type: {conference_room: 1, dropin: 2}


  accepts_nested_attributes_for :facility_plans, reject_if: lambda { |attributes| attributes['plan_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :facility_keys, reject_if: :all_blank

  delegate :name, to: :shop, prefix: true, allow_nil: true

  mount_uploader :image, ImageUploader

  validates :name, presence: true

  scope(:belongs_to_corporation, ->(corporation) { includes(shop: :corporation).where(shops: { corporation_id: corporation.id }) })

  def min_hourly_price(user, target_time=nil)
    plan_ids = user.present? ? user.user_contracts.pluck(:plan_id) : []
    ftps = self.facility_temporary_plans.where.not(standard_price_per_hour: 0).
      where(plan_id: nil).or(self.facility_temporary_plans.where(plan_id: plan_ids))
    options = FacilityTemporaryPlanPrice.where.not(price: 0).where(facility_temporary_plan_id: ftps.pluck(:id).push(nil))
    al = FacilityTemporaryPlanPrice.arel_table
    options = options.where(al[:starting_time].lteq(target_time.to_s(:time))).where(al[:ending_time].gt(target_time.to_s(:time))) if target_time.present?
    option_min_price = options.minimum(:price)
    min_price = ftps.minimum(:standard_price_per_hour)
    min_price = option_min_price if option_min_price.present? && option_min_price < min_price
    min_price
  end

  def self.sync_from_api(ks_corporation_id)
    KeystationService.sync_rooms(ks_corporation_id)
  end

  def self.logout_spots
    facility_ids = FacilityTemporaryPlan.where(plan_id: nil).map(&:facility_id)
    Facility.where(id: facility_ids)
  end

  def calc_price(user, start, hour)
    sum = 0
    (1..hour).each do |i|
      min = self.min_hourly_price(user, start + (i - 1).hours)
      sum = sum + min
    end
    sum
  end

  def available_reservation_area(date)
    y, m, d = date.split('-')
    next_date = (DateTime.parse(date) + 1.day).to_s(:date)
    reservation = reservations.in_range(date..next_date)
    total = reservation.size
    opening_date_and_time = shop.assign_date_for_opening(y, m, d).to_s(:datetime)
    closing_date_and_time = shop.assign_date_for_closing(y, m, d).to_s(:datetime)

    arr = []
    return [[opening_date_and_time, closing_date_and_time]] if total == 0
    reservation.order(:checkin).each_with_index do |r, i|
      if i == 0
        if shop.opening_time.to_s(:time) != r.checkin.to_s(:time)
          arr << opening_date_and_time
          arr << r.checkin.to_s(:datetime)
        end
        arr << r.checkout.to_s(:datetime) if shop.closing_time.to_s(:time) != r.checkout.to_s(:time)
      else
        arr << r.checkin.to_s(:datetime)
        arr << r.checkout.to_s(:datetime) if shop.closing_time.to_s(:time) != r.checkout.to_s(:time)
      end
      arr << closing_date_and_time if i == total - 1 && shop.closing_time.to_s(:time) != r.checkout.to_s(:time)
    end
    arr.each_slice(2).to_a
  end

  def get_temporary_plan_names
    arr = []
    facility_temporary_plans.each do |ftp|
      arr << "#{ftp.try(:plan).try(:name)} "
    end
    arr
  end
end
