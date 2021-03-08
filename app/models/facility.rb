class Facility < ApplicationRecord
  include KsCheckinApi

  acts_as_paranoid
  belongs_to :shop
  has_many :facility_plans, dependent: :destroy
  has_many :plans, through: :facility_plans
  has_many :facility_keys, dependent: :destroy
  has_many :facility_temporary_plans, dependent: :destroy
  has_many :facility_pack_plans, dependent: :destroy
  has_many :facility_dropin_plans, dependent: :destroy
  has_many :reservations, dependent: :restrict_with_exception
  has_many :dropin_reservations, dependent: :restrict_with_exception
  has_many :chartered_facilities, dependent: :destroy
  accepts_nested_attributes_for :chartered_facilities, allow_destroy: true
  validates :chartered_facilities, associated: true

  enum facility_type: { conference_room: 1,
                        dropin: 2,
                        accommodation: 3,
                        ks_flexible: 4,
                        chartered_place: 5 }

  enum reservation_type: { rent_without_ksc: 0,
                           rent_with_ksc: 1 }

  accepts_nested_attributes_for :facility_plans, reject_if: lambda { |attributes| attributes['plan_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :facility_keys, reject_if: :all_blank

  delegate :name, to: :shop, prefix: true, allow_nil: true
  delegate :corporation_name, to: :shop, prefix: true, allow_nil: true
  delegate :corporation_id, to: :shop, prefix: true, allow_nil: true

  mount_uploader :image, ImageUploader
  mount_uploader :detail_document, PdfUploader

  validates :name, :address, :facility_type, presence: true
  validates :address, presence: true
  validates :checkin_time_for_stay, presence: true, if: proc { |f| f.accommodation? }
  validates :checkout_time_for_stay, presence: true, if: proc { |f| f.accommodation? }
  validates :reservation_type, presence: true

  scope(:has_facility_dropin_sub_plans, ->(sub_plan_ids) {
    includes(facility_dropin_plans: :facility_dropin_sub_plans)
    .where(facility_dropin_plans: { facility_dropin_sub_plans: { id: sub_plan_ids } }) })

  scope(:belongs_to_corporation, ->(corporation) { includes(shop: :corporation).where(shops: { corporation_id: corporation.id }) })

  scope :order_by_min_price, -> (facilities, user) {
    @facilities = facilities.sort_by { |f| f.accommodation? ? f.min_daily_price(user) : f.min_hourly_price(user) }
    sanitized_id_string = @facilities.map {|f| f[:id]}.join(",")
    where(id: @facilities).order("FIELD(id, #{sanitized_id_string})")
  }

  scope :filter_by_shop, ->(shop_id = nil) { where(shop_id: shop_id) if shop_id.present? }

  scope :filter_by_users_browsable_range, ->(user) {
    shop_ids = Shop.filter_by_browsable_range(user).pluck(:id)
    where(shop_id: shop_ids)
  }

  def users_pack_plans(user)
    facility_pack_plans.select_pack_plans_for_user_condition(user)
  end

  def unit_times(user)
    users_pack_plans(user).pluck(:unit_time).uniq
  end

  def min_prices_for_each_unit_time(user)
    unit_times(user).map { |unit_time| users_pack_plans(user).where(unit_time: unit_time)&.minimum(:unit_price) || 0 }
  end

  def choosable_pack_plans(user)
    min_prices_for_each_unit_time(user).map { |min| users_pack_plans(user).where(unit_price: min) }
  end

  def choosable_temporary_plans(user)
    facility_temporary_plans.select_plans_for_user_condition(user)
  end

  def facility_temporary_plan_prices
    facility_temporary_plans.map(&:facility_temporary_plan_prices).flatten
  end

  def facility_dropin_sub_plans
    facility_dropin_plans.map(&:facility_dropin_sub_plans).flatten
  end

  def self.vacancy_facilities(condition, user)
    # 都度課金可能な施設を一覧で取得
    facilities = user.present? ? user.login_spots : Facility.logout_spots
    facilities = facilities.where(shop_id: Shop.filter_by_disclosure_range(user))
    # 予約済みの施設を除外する
    acm_date_req = ((condition[:checkin]).to_date..(condition[:checkout]).to_date.yesterday).select(&:day)
    acm_facilities = facilities.accommodation
    future_rsvs = Reservation.where(facility_id: acm_facilities.pluck(:id)).future_rsvs
    reserved_facility_ids = []
    future_rsvs.each do |rsv|
      reserved_date_array = (rsv.checkin.to_date..rsv.checkout.to_date.yesterday).select(&:day)
      reserved = acm_date_req.any? { |date| reserved_date_array.include?(date) }
      reserved ? reserved_facility_ids << rsv.facility_id : next
    end
    facilities = acm_facilities.where.not(id: reserved_facility_ids.uniq)
    # 最大収容人数が予約人数を下回る施設は削除
    facilities = facilities.where('max_num >= ?', condition[:use_num].to_i)
  end

  # 現在予約可能な施設一覧
  def self.reservable_facilities(checkin, checkout, condition, user)
    # 都度課金可能な施設を一覧で取得
    facilities = user.present? ? user.login_spots : Facility.logout_spots
    facilities = facilities.where(shop_id: Shop.filter_by_disclosure_range(user))
    # 指定時間に予約済の施設は削除
    exclude_facility_ids = Reservation.in_range(checkin .. checkout).pluck(:facility_id).uniq
    facilities = facilities.send(condition[:facility_type]).where.not(id: exclude_facility_ids)
    # 店舗の運営時間外の施設は削除
    facilities = facilities.joins(:shop)
      .where(Shop.arel_table[:opening_time].lteq(checkin))
      .where(Shop.arel_table[:closing_time].gteq(checkout))
    # 最大収容人数が予約人数を下回る施設は削除
    facilities = facilities.where('max_num >= ?',  condition[:use_num].to_i)
    # 貸し切り施設の場合紐づく施設が予約で埋まってたら削除
    exclude_facility_ids = []
    facilities.chartered_place.each{ |f|
      exclude_facility_ids << f.id if !f.associated_facilities_available?(checkin, checkout) }
    facilities = facilities.where.not(id: exclude_facility_ids)
  end

  def min_daily_price(user)
    min_price = min_price_of_facility_temporary_plans_for_stay(user)
    price = compute_discount_price(min_price, user)
    (price * Payment::TAX_RATE).floor
  end

  # userに表示し得る施設の最小利用料金(1時間)
  def min_hourly_price(user, target_time=nil)
    min_price = compute_min_price(user, target_time)
    price = compute_discount_price(min_price, user)
    (price * Payment::TAX_RATE).floor
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

  def calc_price_for_stay(user, checkin, checkout)
    return if user.nil?
    min = min_daily_price(user)
    acm_date_req = (Date.parse(checkin)..Date.parse(checkout).yesterday).select(&:day)
    number_of_nights = acm_date_req.count
    min * number_of_nights
  end

  def calc_price_for_pack(user, pack_plan_id)
    return if user.nil?
    (FacilityPackPlan.find(pack_plan_id).unit_price * Payment::TAX_RATE).floor
  end

  def self.sync_from_api(ks_corporation_id)
    KeystationService.sync_rooms(ks_corporation_id)
  end

  def self.logout_spots
    facility_ids = FacilityTemporaryPlan.where(plan_id: nil).map(&:facility_id) + FacilityPackPlan.where(plan_id: nil).map(&:facility_id)
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
        arr << opening_date_and_time
        arr << r.checkin.to_s(:datetime)
        arr << r.checkout.to_s(:datetime)
      else
        arr << r.checkin.to_s(:datetime)
        arr << r.checkout.to_s(:datetime)
      end
      arr << closing_date_and_time if i == total - 1
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

  def set_chartered
    self.chartered = chartered_place?
  end

  # 貸し切り施設に紐付いてる施設一覧を取得
  def associated_facilities
    return nil if !chartered? && !parent_facilities
    return parent_facilities if !child_facilities
    return child_facilities if !parent_facilities
  end

  def parent_facilities
    chartered_facilities = CharteredFacility.where(child_facility_id: id)
    return nil if chartered_facilities.blank?
    Facility.where(id: chartered_facilities.pluck(:facility_id))
  end

  def child_facilities
    return nil if chartered_facilities.blank?
    Facility.where(id: chartered_facilities.map{|cf| cf.child_facility_id})
  end

  # 紐付いてる施設が全て予約可能かどうか判定
  def associated_facilities_available?(checkin, checkout)
    return false if !chartered?
    unavailable_associated_facility_ids(checkin, checkout).blank?
  end

  # 使えない紐付き施設のid一覧
  def unavailable_associated_facility_ids(checkin, checkout)
    return nil if !chartered?
    reservations = Reservation
                    .where(facility_id: associated_facilities.pluck(:id))
                    .in_range(checkin .. checkout)
    reservations.pluck(:facility_id)
  end

  # 貸し切り施設の一部として登録されているかどうか
  def include_chartered_place?
    CharteredFacility.where(child_facility_id: id).present?
  end

  private

  def compute_min_price(user, target_time)
    min_price = min_price_of_facility_temporary_plans(user)
    option_min_price = min_price_of_target_facility_temporary_plan_prices(user, target_time)
    min_price = option_min_price if !option_min_price.zero?
    min_price
  end

  def min_price_of_facility_temporary_plans(user)
    facility_temporary_plans.select_plans_for_user_condition(user)&.minimum(:standard_price_per_hour) || 0
  end

  def min_price_of_facility_temporary_plans_for_stay(user)
    facility_temporary_plans.select_plans_for_user_condition_for_stay(user)&.minimum(:standard_price_per_day) || 0
  end

  def min_price_of_target_facility_temporary_plan_prices(user, target_time)
    target_facility_temporary_plans = facility_temporary_plans.select_plans_for_user_condition(user)
    facility_temporary_plan_prices = FacilityTemporaryPlanPrice.squeeze_from_plans_and_time(target_facility_temporary_plans, target_time)
    facility_temporary_plan_prices&.minimum(:price) || 0
  end

  def compute_discount_price(price, user)
    return price if not_need_to_discount?(user)
    (price * Settings.discount_rate).floor
  end

  def not_need_to_discount?(user)
    user.nil? || user.contract_plan_ids.blank? || shop.corporation.plans_linked_with_user?(user)
  end
end
