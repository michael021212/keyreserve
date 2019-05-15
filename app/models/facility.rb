class Facility < ApplicationRecord

  acts_as_paranoid
  belongs_to :shop
  has_many :facility_plans, dependent: :destroy
  has_many :plans, through: :facility_plans
  has_many :facility_keys, dependent: :destroy
  has_many :facility_temporary_plans, dependent: :destroy
  has_many :facility_dropin_plans, dependent: :destroy
  has_many :reservations, dependent: :restrict_with_exception
  has_many :dropin_reservations, dependent: :restrict_with_exception

  enum facility_type: {conference_room: 1, dropin: 2, rent: 3, car: 4}

  accepts_nested_attributes_for :facility_plans, reject_if: lambda { |attributes| attributes['plan_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :facility_keys, reject_if: :all_blank

  delegate :name, to: :shop, prefix: true, allow_nil: true
  delegate :corporation_name, to: :shop, prefix: true, allow_nil: true

  mount_uploader :image, ImageUploader

  validates :name, :address, presence: true
  validates :address, presence: true, if: proc { |f| f.rent? }

  scope(:has_facility_dropin_sub_plans, ->(sub_plan_ids) {
    includes(facility_dropin_plans: :facility_dropin_sub_plans)
    .where(facility_dropin_plans: { facility_dropin_sub_plans: { id: sub_plan_ids } }) })

  scope(:belongs_to_corporation, ->(corporation) { includes(shop: :corporation).where(shops: { corporation_id: corporation.id }) })

  scope :order_by_min_price, -> (facilities, user) {
    @facilities = facilities.sort_by { |f| f.min_hourly_price(user) }
    sanitized_id_string = @facilities.map {|f| f[:id]}.join(",")
    where(id: @facilities).order("FIELD(id, #{sanitized_id_string})")
  }

  def facility_temporary_plan_prices
    facility_temporary_plans.map(&:facility_temporary_plan_prices).flatten
  end

  def facility_dropin_sub_plans
    facility_dropin_plans.map(&:facility_dropin_sub_plans).flatten
  end

  # 現在予約可能な施設一覧
  def self.reservable_facilities(checkin, checkout, condition, user)
    # 都度課金可能な施設を一覧で取得
    facilities = user.try(:logged_in?) ? user.login_spots : Facility.logout_spots
    # 指定時間に予約済の施設は削除
    exclude_facility_ids = Reservation.in_range(checkin .. checkout).pluck(:facility_id).uniq
    facilities = facilities.send(condition[:facility_type]).where.not(id: exclude_facility_ids)
    # 店舗の運営時間外の施設は削除
    facilities = facilities.joins(:shop)
      .where(Shop.arel_table[:opening_time].lteq(checkin))
      .where(Shop.arel_table[:closing_time].gteq(checkout))
    # 最大収容人数が予約人数を下回る施設は削除
    facilities = facilities.where('max_num > ?',  condition[:use_num].to_i)
  end

  # userに表示し得る施設の最小利用料金(1時間)
  def min_hourly_price(user, target_time=nil)
    temporary_plans = (get_temporary_plans_linked_with_user(user).presence || get_temporary_plans_of_not_contracts.presence)
    temporary_plan_prices = get_temporary_plan_prices_linked_with_temporary_plan_ids(temporary_plans&.ids)
    temporary_plan_prices = temporary_plan_prices.in_time(target_time) if temporary_plan_prices.present? && target_time.present?
    min_price = get_min_price_from_target_temporary_plans(temporary_plans)
    option_min_price = get_min_price_from_target_temporary_plan_prices(temporary_plan_prices)
    min_price = option_min_price if !option_min_price.zero?
    compute_discount_price(min_price, user)
  end

  # userに表示し得る施設の最小利用料金(30分)
  def min_half_hourly_price(user, target_time=nil)
    min_hourly_price(user, target_time) / 2
  end

  def calc_price(user, start, usage_hour)
    sum = 0
    return if user.nil?
    while(usage_hour > 0) do
      min = min_half_hourly_price(user, start)
      sum = sum + min
      start = start + 0.5.hours
      usage_hour -= 0.5
    end
    sum
  end

  def self.sync_from_api(ks_corporation_id)
    KeystationService.sync_rooms(ks_corporation_id)
  end

  def self.logout_spots
    facility_ids = FacilityTemporaryPlan.where(plan_id: nil).map(&:facility_id)
    Facility.where(id: facility_ids)
  end

  def self.logout_dropin_spots
    facility_ids = FacilityDropinPlan.where(plan_id: nil).map(&:facility_id)
    Facility.where(id: facility_ids)
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

  def facility_dropin_plans_in_contract(user)
    p_ids = []
    p_ids << user.user_contracts.pluck(:plan_id) if user.present?
    p_ids << nil
    p_ids.flatten!
    facility_dropin_plans.where(plan_id: p_ids)
  end

  def self.recommended_sub_plan(facility_id, dropin_spot_params, user)
    return if dropin_spot_params['checkin_time'].blank?
    facility = Facility.find(facility_id)
    checkin = Time.zone.parse(dropin_spot_params[:checkin] + " " + dropin_spot_params[:checkin_time])
    checkout = checkin + dropin_spot_params[:use_hour].to_i.hours
    facility_dropin_plan_ids = facility.facility_dropin_plans_in_contract(user).pluck(:id)
    sub_plan_ids = FacilityDropinSubPlan.belongs_to_facility(facility_id).pluck(:id)
    FacilityDropinSubPlan.in_range(checkin..checkout).where(id: sub_plan_ids).where(facility_dropin_plan_id: facility_dropin_plan_ids).order('price ASC').first
  end

  def set_geocode
    uri = URI.escape("https://maps.googleapis.com/maps/api/geocode/json?address="+self.address.gsub(" ", "")+"&key=#{Settings.google_key}")
    res = HTTP.get(uri).to_s
    response = JSON.parse(res)
    if response['results'].present?
      self.lat = response["results"][0]["geometry"]["location"]["lat"]
      self.lon = response["results"][0]["geometry"]["location"]["lng"]
    end
  end

  private

  def get_min_price_from_target_temporary_plans(target_temporary_plans)
    return 0 if target_temporary_plans.blank?
    target_temporary_plans.minimum(:standard_price_per_hour)
  end

  def get_min_price_from_target_temporary_plan_prices(target_temporary_plan_prices)
    return 0 if target_temporary_plan_prices.blank?
    target_temporary_plan_prices.minimum(:price)
  end

  def get_temporary_plan_prices_linked_with_temporary_plan_ids(temporary_plan_ids)
    return [] if facility_temporary_plan_prices.blank? || temporary_plan_ids.blank?
    FacilityTemporaryPlanPrice.not_zero_yen.target_temporary_plan_ids(temporary_plan_ids)
  end

  def get_temporary_plans_linked_with_user(user)
    return [] if user&.get_contract_plan_ids.blank?
    facility_temporary_plans.target_plan_ids(user.get_contract_plan_ids)
  end

  def get_temporary_plans_of_not_contracts
    facility_temporary_plans.not_zero_yen.plan_id_nil
  end

  def compute_discount_price(price, user)
    (price * discount_rate(user)).floor
  end

  def discount_rate(user)
    return 1 if user.nil? || get_temporary_plans_linked_with_user(user).present?
    user.user_contracts.present? ? Settings.discount_rate : 1
  end
end
