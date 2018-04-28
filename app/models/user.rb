class User < ApplicationRecord
  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users, dependent: :destroy
  has_many :corporations, through: :corporation_users
  has_many :user_contracts, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  belongs_to :user_corp, foreign_key: :parent_id, optional: true
  delegate :name, to: :user_corp, prefix: true, allow_nil: true

  accepts_nested_attributes_for :corporation_users

  enum state: { registered: 0, activated: 1 }
  enum payway: { creditcard: 1, invoice: 2 }
  enum user_type: { personal: 1, parent_corporation: 2 }

  validates :name, :email, presence: true, length: { maximum: 255 }
  validates :email, email: true, uniqueness: true
  validates :tel,
            presence: true, length: { maximum: 13 }
  validates :password, confirmation: true, presence:true, length: { minimum: 4, maximum: 20, allow_blank: true }, if: -> { new_record? || changes[:crypted_password] }

  scope(:user_corp_token, ->(token) { find_by(parent_token: token) })
  scope(:parent_is_nil, -> { where(parent_id: nil) })

  def available_facilities
    Facility.joins(:facility_plans)
            .where(facility_plans: {plan_id: user_contracts.under_contract.pluck(:plan_id)})
  end

  def add_new_user?
    return false if max_user_num.nil?
    try(:max_user_num) > User.where(parent_id: id).count
  end

  def self.has_contract_with_shops(shop_ids)
    User.includes(user_contracts: :shop)
        .where(user_contracts: { shop_id: shop_ids })
        .where.not(user_contracts: { state: UserContract.states[:finished] })
  end

  def self.selectable_user_contracts
     User.personal.parent_is_nil.or(User.parent_corporation)
  end

  def login_spots
    plan_ids = self.user_contracts.map(&:plan_id)
    facility_ids = FacilityTemporaryPlan.where(plan_id: plan_ids).map(&:facility_id)
    Facility.where(id: facility_ids).or(Facility.logout_spots)
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
