class Plan < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation
  has_many :facility_plans, dependent: :destroy
  has_many :facilities, through: :facility_plans
  has_many :facility_temporary_plans, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_integer: true}

  scope(:fetch_shops, ->(shop_id) { includes(facilities: :shop).where(facilities: { shops: { id: shop_id } }) })
  scope(:is_divided_into_facility_temporary_plans, ->(facility_id) { includes(facility_temporary_plans: :facility).where(facility_temporary_plans: { plans: { facilities: { id: facility_id } } }) })

  def self.lowest_price(shop_id)
    return if fetch_shops(shop_id).blank?
    fetch_shops(shop_id).order(price: :asc).first.price
  end
end
