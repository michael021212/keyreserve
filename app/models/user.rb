class User < ApplicationRecord
  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users, dependent: :destroy
  has_many :corporations, through: :corporation_users
  has_many :user_contracts, dependent: :destroy
  has_one :credit_card, dependent: :destroy

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

  def set_stripe_customer
    stripe_customer = Stripe::Customer.create(email: email)
    update(stripe_customer_id: stripe_customer.id)
  end

  def retrieve_stripe_customer
    # Retrieves the details of an existing customer.
    return unless stripe_customer_id
    Stripe::Customer.retrieve(stripe_customer_id)
  end
end
