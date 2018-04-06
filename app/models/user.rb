class User < ApplicationRecord
  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users, dependent: :destroy
  has_many :corporations, through: :corporation_users
  has_many :user_contracts, dependent: :destroy

  accepts_nested_attributes_for :corporation_users

  enum state: { registered: 0, activated: 1 }
  enum payway: { creditcard: 1, invoice: 2 }

  validates :name, :email, presence: true, length: { maximum: 255 }
  validates :email, email: true
  validates :tel,
            presence: true, length: { maximum: 13 }
  validates :password, confirmation: true, presence:true, length: { minimum: 4, maximum: 20, allow_blank: true }, if: -> { new_record? || changes[:crypted_password] }


  def available_facilities
    Facility.joins(:facility_plans)
      .where(facility_plans: {plan_id: user_contracts.under_contract.pluck(:plan_id)})
  end

  def self.has_contract_with_shop(shop_id)
    User.includes(user_contracts: :shop)
        .where(user_contracts: { shop_id: shop_id })
        .where.not(user_contracts: { state: UserContract.states[:finished] })
  end
end
