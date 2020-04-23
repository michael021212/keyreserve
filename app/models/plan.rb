class Plan < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation
  has_many :facility_plans, dependent: :destroy
  has_many :facilities, through: :facility_plans
  has_many :facility_temporary_plans, dependent: :destroy
  has_many :user_contracts

  validates :name, :description, presence: true
  validates :price, presence: true, numericality: {only_integer: true}

  scope(:available_in_shop, ->(shop_id) { includes(facilities: :shop).where(default_flag: true, facilities: { shops: { id: shop_id } }) })
  scope(:fetch_shops, ->(shop_id) { includes(facilities: :shop).where(facilities: { shops: { id: shop_id } }) })
  scope(:temporary_plans_belongs_to_facility, ->(facility_id) { includes(facility_temporary_plans: :facility).where(facility_temporary_plans: { plans: { facilities: { id: facility_id } } }) })

  XYMAX_PLAN_ID = 26

  def self.lowest_price(shop_id)
    return if available_in_shop(shop_id).blank?
    available_in_shop(shop_id).order(price: :asc).first.price
  end
end
