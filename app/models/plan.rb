class Plan < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation
  has_many :facility_plans, dependent: :destroy
  has_many :facilities, through: :facility_plans

  validates :name, :description, presence: true
  validates :price, presence: true, numericality: {only_integer: true}

  scope(:available_in_shop, ->(shop_id) { includes(facilities: :shop).where(default_flag: true, facilities: { shops: { id: shop_id } }) })

  def self.lowest_price(shop_id)
    return if available_in_shop(shop_id).blank?
    available_in_shop(shop_id).order(price: :asc).first.price
  end
end
